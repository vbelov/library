require 'sinatra'
require 'sinatra/activerecord'
require './models/author'
require './models/book'

get '/' do
  {
      authors: Author.count,
      books: Book.count
  }.to_json
end
