require "test_helper"
require "nokogiri"

class ActiveServerTest < VitaeServerTestCase

  test "the homepage contains lists the cvs we're hosting" do
    clear_test_dir
    vitae_create "resumes derek arthur sajal"
    
    get '/'
    assert last_response.ok?
    assert_matches %w[Derek Arthur Sajal]
    assert_select  "a[href='/sajal']", "Sajal"
    
    check_includes_standard_assets
  end
  
  test "a CV gets its own show page" do
    clear_test_dir
    vitae_create "resumes zeena_gunn"
    
    get '/zeena_gunn'
    assert last_response.ok?
    
    assert_select "h1", "Zeena Gunn"
    assert_select "a[href='/']"
    
    check_includes_standard_assets
  end
  
  test "a CV doesn't mindlessly blat out converted yaml data" do
    clear_test_dir
    vitae_create "resumes"
    
    get '/arthur_gunn'
    assert last_response.ok?
    
    assert_no_select "h2", "vitae_config"
  end
  
  def check_includes_standard_assets theme="default"
    assert_select "script[src='/#{theme}/application.js'][type='text/javascript']"
    assert_select "link[href='/#{theme}/application.css'][rel='stylesheet'][type='text/css']"
  end
  
end