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
  
  test "the server responds well" do
    assert_match("Serving CVs", vitae_server("--pretend"))
  end
  
  test "the server accepts a custom port" do
    assert_match(":3141", vitae_server("--pretend"))
    assert_match(":9292", vitae_server("--pretend -p 9292"))
    assert_match(":1121", vitae_server("--pretend -p 1121"))
  end
  
  test "the server gives rackup help" do
    assert_match("Usage: rackup", vitae_server("-h"))
  end
  
end