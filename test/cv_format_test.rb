require "test_helper"
require "nokogiri"

class CvFormatTest < VitaeServerTestCase
  
  test "a CV has a well formatted vcard" do
    with_project :default do
      get '/arthur_gunn'
      assert last_response.ok?
    
      assert_select ".vcard" do
        assert_select "h1#title.fn", "Arthur Gunn"
        assert_select "ul#quick-links li" do
          assert_select "span.label", "github"
          assert_select "a.url[href='https://github.com/gunn']", "github"
          assert_select "span.label", "e-mail"
          assert_select "a.email[href='mailto:arthur@gunn.co.nz']", "arthur@gunn.co.nz"
        end
        assert_select "span.adr" do
          assert_select "span.street-address", "96 London St."
          assert_select "span.postal-code", "9016"
        end
      end
      
    end
  end
  
end