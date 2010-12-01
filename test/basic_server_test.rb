require ::File.expand_path('../../lib/vitae/server/config/environment',  __FILE__)
require 'test_helper'
require 'rack/test'

class BasicServerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Server::Application
  end

  test "the homepage loads" do
    get '/'
    assert last_response.ok?
    assert_equal 'Hello', last_response.body
  end
  
end