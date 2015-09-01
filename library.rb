require 'sinatra'
require 'sinatra/activerecord'
require './models/author'
require './models/book'

PER_PAGE = 15

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

after do
  ActiveRecord::Base.connection.close
end
