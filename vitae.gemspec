# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "vitae/version"

Gem::Specification.new do |s|
  s.name        = "vitae"
  s.version     = Vitae::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Arthur Gunn"]
  s.email       = ["arthur@gunn.co.nz"]
  s.homepage    = "https://github.com/gunn/vitae"
  s.summary     = %q{A structured CV publishing system.}
  s.description = %q{Vitae is to CVs what rubygems is to ruby code. Still very under development.}
  
  s.add_dependency "sinatra", "~>1.1.0"
  s.add_dependency "haml", "~>3.0.0"
  s.add_dependency "thor", "~>0.14.0"
  
  s.add_development_dependency "nokogiri", "~>1.4.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
