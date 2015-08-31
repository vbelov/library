ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'

require File.expand_path '../library.rb', __FILE__

class LibraryTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_renders_list_of_books
    ActiveRecord::Base.connection.transaction do
      book = Book.create!(name: 'The Pragmatic Programmer', year: 2000)
      book.authors << Author.create!(name: 'Andrew Hunt')
      book.authors << Author.create!(name: 'David Thomas')

      get '/'
      assert last_response.ok?

      raise ActiveRecord::Rollback
    end
  end
end
