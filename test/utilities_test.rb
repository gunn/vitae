require "test_helper"

class UtilitiesTest < VitaeTestCase
  
  test "yaml can be ordered" do
    yaml_hash_string = %q{
    --- !omap 
    - number: !omap 
        - one: 1
        - two: 2
        - three: 3
        - four: 4
        - five: 5
        - six: 6
    }
    yaml_hash = YAML.load yaml_hash_string
    numbers_from_yaml = yaml_hash["number"].map { |k,v| "#{k} = #{v}" }.join("\n")
    
    the_numbers = "one = 1\ntwo = 2\nthree = 3\nfour = 4\nfive = 5\nsix = 6"
    
    assert_equal(the_numbers, numbers_from_yaml)
  end
  
end








