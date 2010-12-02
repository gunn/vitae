require "test_helper"

class BasicServerTest < VitaeServerTestCase

  test "the homepage loads" do
    get '/'
    assert last_response.ok?
  end
  
end