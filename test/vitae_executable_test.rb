require 'test_helper'
# require 'net/http'
# require 'uri'

class VitaeExecutableTest < VitaeTestCase
  
  test "create gives help when called without args" do
    output = vitae_create
    assert_match('"create" was called incorrectly', output)
  end
  
  test "create generates a project" do
    output = vitae_create("my_cvs")
    # assert_match(/project created/, output)
    
    files = %w[my_cvs/cvs/default/cv.yaml
      my_cvs/themes/default/application.js
      my_cvs/themes/default/application.css]
    
    files.each do |file|
      assert(vitae_file?( file ), "#{file} should exist in #{vitae_test_dir}")
    end
  end
  
  test "the server accepts options, gives help" do
    assert_match("Serving CVs", vitae_server("--pretend"))
  end
  
end