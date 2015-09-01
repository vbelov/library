require 'sinatra'
require 'sinatra/activerecord'
require './models/author'
require './models/book'

PER_PAGE = 10

get '/' do
  slim :index
end

get '/books' do
  slim :index
end

get '/api/books' do
  page = params['page'].to_i
  page = 0 if page < 0
  offset = page * PER_PAGE
  @books = Book.order(:id).limit(PER_PAGE).offset(offset)
  @books.to_json(include: :authors)
end

post '/api/books' do
  book = Book.new(name: params['name'], year: params['year'])
  if book.save
    book.to_json
  else
    status 400
    {errors: book.errors.messages, errors2: book.errors.full_messages}.to_json
  end
end

delete '/api/books/:id' do
  book = Book.find_by_id(params[:id])
  if book
    book.destroy
  else
    status 404
    {errors: ["Book with id=#{params[:id]} was not found"]}
  end
end

after do
  ActiveRecord::Base.connection.close
end
