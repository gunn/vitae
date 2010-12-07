$:.unshift File.dirname(File.expand_path(__FILE__))
require "vitae/cv"
require "vitae/ordered_hash"

module Vitae
  @@project_root = nil
  def self.project_root
    @@project_root
  end
  
  def self.project_root= root
    Server.set :public, File.join(root, "themes") if root && defined?(Server)
    @@project_root = root
  end
end