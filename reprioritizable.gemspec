require_relative "lib/reprioritizable/version"

Gem::Specification.new do |spec|
  spec.name        = "reprioritizable"
  spec.version     = Reprioritizable::VERSION
  spec.authors     = ["murakami"]
  spec.email       = ["ek.h1.hy@gmail.com"]
  spec.homepage    = "http://example.com"
  spec.summary     = "Summary of Reprioritizable."
  spec.description = "You can change the priority in the scope"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "Put your gem's CHANGELOG.md URL here."

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.4", ">= 6.1.4.4"
  spec.add_dependency "byebug"
  spec.add_dependency "rspec-rails"
end
