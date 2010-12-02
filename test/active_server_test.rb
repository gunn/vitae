require "test_helper"

class ActiveServerTest < VitaeServerTestCase

  test "the homepage contains lists the cvs we're hosting" do
    clear_test_dir
    vitae_create "resumes derek arthur sajal"
    
    get '/'
    assert last_response.ok?
    assert_matches(%w[Derek Arthur Sajal], last_response.body)
  end
  
  def assert_matches matches, actual
    matches.each do |match|
      assert_match match, actual
    end
  end
  
end