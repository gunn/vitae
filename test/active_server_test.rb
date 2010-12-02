class ActiveServerTest < VitaeServerTestCase

  test "the homepage loads" do
    get '/'
    assert last_response.ok?
    assert_equal 'Hello', last_response.body
  end
  
end