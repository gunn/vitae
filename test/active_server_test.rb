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
  
  test "we have format links" do
    with_project :sals do
      get '/'
      
      assert_select "#download-links" do
        assert_select  "a[href='/sajal_shah']", "html"
        assert_select  "a[href='/sajal_shah.yaml']", "yaml"
        assert_select  "a[href='/sajal_shah.pdf']", "pdf"
      end
    end
  end
  
  test "serves pdfs" do
    with_project :default do
      get '/arthur_gunn.pdf'
      assert last_response.ok?
      
      # how to test this?
    end
  end
  
  test "serves yaml files" do
    with_project :default do
      get '/arthur_gunn.yaml'
      assert last_response.ok?
      
      # check that we get some yaml:
      assert_match %r(--- !omap\n- name: Arthur Gunn), last_response.body
    end
  end
  
  test "repsonds to pages with .html extension" do
    with_project :default do
      get '/arthur_gunn.html'
      assert last_response.ok?
      
      # do some standard content checks:
      check_includes_standard_assets
      assert_select "h1", "Arthur Gunn"
    end
  end
  
  test "gives error if user requests an unsupported extension" do
    with_project :default do
      get '/arthur_gunn.bogus'
      # assert !last_response.ok?
      
      assert_equal("Sorry, we don't have anything with a .bogus extension here.", last_response.body)
    end
  end
  
  def check_includes_standard_assets theme="default"
    assert_select "script[src='/#{theme}/application.js'][type='text/javascript']"
    assert_select "link[href='/#{theme}/application.css'][rel='stylesheet'][type='text/css']"
  end
  
end