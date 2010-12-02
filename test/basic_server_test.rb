require 'lib/vitae/server/server'
require 'rack/test'

class BasicServerTest < VitaeTestCase
  include Rack::Test::Methods

  def app
    Server
  end

  test "the homepage loads" do
    get '/'
    assert last_response.ok?
    assert_equal 'Hello', last_response.body
  end
  
end