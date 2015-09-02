require 'sinatra'
require 'sinatra/activerecord'
require './models/author'
require './models/book'

PER_PAGE = 10
MOST_PRODUCTIVE_AUTHORS = 10

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

get '/stats' do
  slim :stats
end

get '/api/stats/books_per_year' do
  Book.per_year_stats.to_json
end

get '/api/stats/books_of_most_productive_authors' do
  Book.per_year_stats(MOST_PRODUCTIVE_AUTHORS).to_json
end

get '/api/stats/first_letter_of_book_title' do
  sql = 'select first_letter, count(*)
          from books
          group by first_letter
          order by first_letter;'
  result = Book.connection.exec_query(sql)
  result.to_json
end

delete '/api/books_for_year' do
  year = params['year']
  Book.delete_all_for_year(year)
  {}
end

after do
  ActiveRecord::Base.connection.close
end
