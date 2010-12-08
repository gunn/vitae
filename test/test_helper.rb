require 'fileutils'
require 'test/unit'
require "stringio"

require 'rubygems'
require 'rack/test'

require File.expand_path('../../lib/vitae', __FILE__)
require 'vitae/server/server'
require "vitae/cli"

class VitaeTestCase < Test::Unit::TestCase
  def self.test name, &block
    name = "test #{name}"#.split(/[^a-z1-9]+/).compact.join("_")
    define_method name, &block
  end
  
  @@projects = {
    :default => "",
    :sals => "sajal_shah",
    :dkaz => "derek katya arthur zeena"
  }
  
  @@vitae_test_dir   = File.expand_path('../../tmp', __FILE__)
  @@vitae_executable = File.expand_path('../../bin/vitae', __FILE__)
  
  test "tests working here" do
    # assert(true, "Just to keep t/u happy.")
  end
  
  def vitae_test_dir
    FileUtils.mkdir_p @@vitae_test_dir
  end
  
  def vitae_executable
    @@vitae_executable
  end
  
  def vitae_server args=""
    cli = Vitae::CLI.new
    real_argv = ARGV
    ARGV.replace(args.split(/\s+/))
    get_stdout_and_stderr { cli.server }
  ensure
    ARGV.replace(real_argv)
  end
  
  def vitae_create args=""
    FileUtils.cd vitae_test_dir
    cli = Vitae::CLI.new
    args = args.split(/\s+/)
    project_name = args.first || ""
    Vitae::project_root = File.join(vitae_test_dir, project_name)
    
    get_stdout_and_stderr { cli.create(*args) }
  end
  
  def with_project name, &block
    project_dir = File.join(vitae_test_dir, name.to_s)
    vitae_create "#{project_dir} #{@@projects[name]}" if !File.exist?( project_dir )
    Vitae::project_root = project_dir
    FileUtils.cd project_dir
    yield
  ensure
    Vitae::project_root = ''
  end
  
  def get_stdout_and_stderr &block
    new_out = StringIO.new
    real_stdout, $stdout = $stdout, new_out
    real_stderr, $stderr = $stderr, new_out
    yield
    new_out.string
  ensure
    $stderr = real_stderr
    $stdout = real_stdout
  end
  
  def clear_test_dir
    FileUtils.rm_r vitae_test_dir
  end
  
  def vitae_file? path
    File.exist? File.expand_path(path, vitae_test_dir)
  end
  
end

class VitaeServerTestCase < VitaeTestCase
  include Rack::Test::Methods

  def app
    Server
  end
  
  def assert_matches matches, actual=last_response.body
    matches.each do |match|
      assert_match match, actual
    end
  end
  
  def assert_no_select selector, content=nil
    assert_select selector, content, :want_matches => false
  end
  
  def assert_select selector, content=nil, options={}
    options = { :want_matches => true }.merge(options)
    
    text         = options[:text] || last_response.body
    want_matches = options[:want_matches]
    
    selector = "#{@parent_selector} #{selector}" if @parent_selector
    
    elements = Nokogiri::HTML.parse(text).css(selector)
    have_matches = elements.size>0
    
    did_match = if content
      elements.any? { |el| el.content.match content }
    else
      have_matches
    end
    
    if !want_matches
      assert(!did_match, "Found matches for the selector '#{selector}', but we didn't want any.")
    else
      assert(did_match, "No matches for the selector '#{selector}'.") if !content
      assert(did_match, "No matches for '#{content}' with the selector '#{selector}'.") if content
    end
  
    if block_given? && have_matches
      begin
        in_scope, @parent_selector = @parent_selector, selector
        yield
      ensure
        @parent_selector = in_scope
      end
    end
    
  end
  
end