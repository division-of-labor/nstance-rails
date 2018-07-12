$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "nstance/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nstance-rails"
  s.version     = Nstance::Rails::VERSION
  s.authors     = ["Mason Stewart", "Amy Burka"]
  s.email       = ["masondesu@gmail.com", "aburka@gmail.com"]
  s.homepage    = "https://divisionoflabor.xyz"
  s.summary     = "Summary of Nstance::Rails."
  s.description = "Description of Nstance::Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.0"
  s.add_dependency "jwt", "~> 2.1.0"
  s.add_dependency "dotenv-rails", "~> 2.5.0"
  s.add_dependency "puma"
  s.add_dependency "redis", "~> 4.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "pry-rails"
end
