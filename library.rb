require 'sinatra'
require 'sinatra/activerecord'
require './models/author'
require './models/book'

get '/' do
  @books = Book.order(:id).limit(15)

  slim :index
end
