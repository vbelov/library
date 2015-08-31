ENV['RACK_ENV'] = 'test'
require 'test/unit'
require 'rack/test'

require File.expand_path '../library.rb', __FILE__

class LibraryTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_says_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello world!', last_response.body
  end
end
