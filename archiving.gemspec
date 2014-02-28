$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "archiving/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "archiving"
  s.version     = Archiving::VERSION
  s.authors     = ["Harry Vangberg"]
  s.email       = ["hv@firmafon.dk"]
  s.homepage    = "https://github.com/firmafon/archiving"
  s.summary     = "MySQL Archive Tables"
  s.description = "Archiving things"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.17"
  s.add_dependency "mysql2"
end
