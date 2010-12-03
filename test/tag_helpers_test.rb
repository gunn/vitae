require "test_helper"
require 'vitae/server/helpers'

class VitaeExecutableTest < VitaeTestCase
  module Help
    extend Helpers
  end
  
  test "link_to helper produces well formed links" do
    assert_equal "<a href='about_us'>About Us</a>", Help.link_to("About Us")
    assert_equal "<a href='http://google.com'>Search Time!</a>", Help.link_to("Search Time!", "http://google.com")
  end
  
  test "content_tag helper produces well formed tags" do
    assert_equal "<h1>Title!</h1>", Help.content_tag(:h1, "Title!")
    assert_equal "<script src='/fast.js'></script>", Help.content_tag(:script, :src => "/fast.js")
  end
  
  test "tag helper produces well formed tags" do
    assert_equal "<br/>", Help.tag(:br)
    assert_equal "<link href='/pretty.css'/>", Help.tag(:link, :href => "/pretty.css")
  end
  
end