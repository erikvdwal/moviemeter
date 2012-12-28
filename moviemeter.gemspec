# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "moviemeter/version"

Gem::Specification.new do |s|
  s.name        = "moviemeter"
  s.version     = Moviemeter::VERSION
  s.authors     = ["Erik van der Wal"]
  s.email       = ["erikvdwal@gmail.com"]
  s.homepage    = "http://www.erikvdwal.nl/"
  s.summary     = %q{Simple library to talk to the MovieMeter API (Dutch)}
  s.description = %q{Simple library to talk to the MovieMeter API (Dutch)}

  s.rubyforge_project = "moviemeter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
end
