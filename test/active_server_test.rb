require "test_helper"
require "nokogiri"

class ActiveServerTest < VitaeServerTestCase

  test "the homepage contains lists the cvs we're hosting" do
    clear_test_dir
    vitae_create "resumes derek arthur sajal"
    
    get '/'
    assert last_response.ok?
    assert_matches(%w[Derek Arthur Sajal])
    assert_select("a[href='/sajal']", "Sajal")
  end
  
  test "a CV gets its own show page" do
    clear_test_dir
    vitae_create "resumes arthur_gunn"
    
    get '/arthur_gunn'
    assert last_response.ok?
    
    assert_select("h1", "Arthur Gunn")
    assert_select("a[href='/']")
  end
  
end