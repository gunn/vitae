require "test_helper"
require "nokogiri"

class ActiveServerTest < VitaeServerTestCase

  test "the homepage contains lists the cvs we're hosting" do
    with_project :dkaz do
      get '/'
      assert last_response.ok?
      assert_matches %w[Katya Derek Arthur Zeena]
      assert_select  "a[href='/katya']", "Katya"
      assert_select  "a[href='/zeena']", "Zeena"
      
      check_includes_standard_assets
    end
  end
  
  test "a CV gets its own show page" do
    with_project :sals do
      get '/sajal_shah'
      assert last_response.ok?
    
      assert_select "h1", "Sajal Shah"
    
      check_includes_standard_assets
    end
  end
  
  test "a CV doesn't mindlessly blat out converted yaml data" do
    with_project :default do
      get '/arthur_gunn'
      assert last_response.ok?
    
      assert_no_select "h2", "vitae_config"
    end
  end
  
  test "if there's only one CV it should be at the root" do
    with_project :sals do
      get '/'
      assert last_response.ok?
    
      assert_select "h1", "Sajal Shah"
      assert_no_select "a[href='/']"
    
      check_includes_standard_assets
    end
  end
  
  def check_includes_standard_assets theme="default"
    assert_select "script[src='/#{theme}/application.js'][type='text/javascript']"
    assert_select "link[href='/#{theme}/application.css'][rel='stylesheet'][type='text/css']"
  end
  
end