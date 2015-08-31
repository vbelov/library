ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'

require File.expand_path '../library.rb', __FILE__

class LibraryTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_returns_num_of_authors_and_books
    ActiveRecord::Base.connection.transaction do
      Book.create!(name: 'The Pragmatic Programmer', year: 2000)
      Author.create!(name: 'Andrew Hunt')
      Author.create!(name: 'David Thomas')

      get '/'
      assert last_response.ok?
      json = JSON.parse(last_response.body)
      assert_equal json['authors'], 2
      assert_equal json['books'], 1

      raise ActiveRecord::Rollback
    end
  end
end
