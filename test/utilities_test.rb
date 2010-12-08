require "test_helper"

class UtilitiesTest < VitaeTestCase
  
  test "we can capture stdout and stderr" do
    captured_string = get_stdout_and_stderr do
      puts "hello!"
      print "h"
      puts "i"
      $stderr.print "bye!"
    end
    expected_string = "hello!\nhi\nbye!"
    
    assert_equal(expected_string, captured_string)
  end
  
  test "yaml can be ordered" do
    numbers_from_yaml = example_yaml_hash["numbers"].map { |k,v| "#{k} = #{v}" }.join("\n")
    
    the_numbers = "one = 1\ntwo = 2\nthree = 3\nfour = 4\nfive = 5\nsix = 6"
    
    assert_equal(the_numbers, numbers_from_yaml)
  end
  
  test "ordered hash items can be skipped" do
    number_string = example_yaml_hash["numbers"].except(%w[one three four five]).map { |k,v| k }.join(", ")
    assert_equal("two, six", number_string)
  end
  
  def example_yaml_hash
    yaml_hash_string = %q{
    --- !omap 
    - numbers: !omap 
        - one: 1
        - two: 2
        - three: 3
        - four: 4
        - five: 5
        - six: 6
    }
    yaml_hash = YAML.load yaml_hash_string
  end
  
  test "CV.first and CV.last do their jobs" do    
    with_project :dkaz do
      assert_equal "Arthur", CV.first.name
      assert_equal "Zeena", CV.last.name
    end
  end
  
end
