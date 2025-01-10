$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "archiving"
  s.version     = File.read('VERSION')
  s.authors     = ["Harry Vangberg", "Michael Kyed", "Henrik Bjørnskov"]
  s.email       = ["teknik@relatel.dk"]
  s.homepage    = "https://github.com/firmafon/archiving"
  s.summary     = "MySQL Archive Tables"
  s.description = "Archiving aged records to archive table"

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "activerecord", ">= 4.2", "< 8.0"
  s.add_dependency "mysql2"

  s.add_development_dependency "rails", ">= 4.2", "<= 8.1"
  s.add_development_dependency "rake"
  s.add_development_dependency "rr"
  s.add_development_dependency "minitest-focus"
end
