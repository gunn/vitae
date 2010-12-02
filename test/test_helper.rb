require 'fileutils'
require 'test/unit'

require File.expand_path('../../lib/vitae', __FILE__)
require 'vitae/server/server'
require 'rack/test'

VITAE_TEST_DIR   = ::File.expand_path('../../tmp', __FILE__)
VITAE_EXECUTABLE = ::File.expand_path('../../bin/vitae', __FILE__)

class VitaeTestCase < Test::Unit::TestCase
  def self.test name, &block
    name = "test #{name}"#.split(/[^a-z1-9]+/).compact.join("_")
    define_method name, &block
  end
  
  test "tests working here" do
    # assert(true, "Just to keep t/u happy.")
  end
  
  def vitae_test_dir
    FileUtils.mkdir_p VITAE_TEST_DIR
  end
  
  def vitae_executable
    VITAE_EXECUTABLE
  end
  
  %w[server].each do |command|
    define_method "vitae_#{command}" do |*args|
      args = args.first
      FileUtils.cd vitae_test_dir
      `#{vitae_executable} #{command} #{args} 2>&1`
    end
  end
  
  def vitae_create args=""
    FileUtils.cd vitae_test_dir
    project_name = args.split(/\s+/).first || ""
    Server.project_root = File.join(vitae_test_dir, project_name)
    `#{vitae_executable} create #{args} 2>&1`
  end
  
  def clear_test_dir
    FileUtils.rm_r vitae_test_dir
  end
  
  def vitae_file? path
    File.exist? ::File.expand_path(path, vitae_test_dir)
  end
  
end

class VitaeServerTestCase < VitaeTestCase
  include Rack::Test::Methods

  def app
    Server
  end
end