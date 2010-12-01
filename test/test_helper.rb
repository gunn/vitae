require 'test/unit'

module TestHelpers
  def test name, &block
    name = "test #{name}"#.split(/[^a-z1-9]+/).compact.join("_")
    define_method name, &block
  end
end

Test::Unit::TestCase.send :extend, TestHelpers