ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'

require File.expand_path '../library.rb', __FILE__

class LibraryTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_returns_list_of_books_with_authors
    ActiveRecord::Base.connection.transaction do
      book = Book.create!(name: 'The Pragmatic Programmer', year: 2000)
      book.authors << Author.create!(name: 'Andrew Hunt')
      book.authors << Author.create!(name: 'David Thomas')

      get '/api/books?page=0'
      assert last_response.ok?

      json = JSON.parse(last_response.body)
      assert_equal json.count, 1

      api_book = json.first
      assert_equal api_book['name'], book.name

      api_authors = api_book['authors']
      assert_equal api_authors.count, 2
      assert_equal api_authors.map { |a| a['name'] }.sort, book.authors.map(&:name).sort

      raise ActiveRecord::Rollback
    end
  end
end
