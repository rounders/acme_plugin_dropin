$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "acme_plugin_dropin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "acme_plugin_dropin"
  spec.version     = AcmePluginDropin::VERSION
  spec.authors     = ["Francois Harbec"]
  spec.email       = ["fharbec@gmail.com"]
  spec.homepage    = "https://github.com/rounders/acme_plugin_dropin"
  spec.summary     = "drop in replacement for acme_plugin gem"
  spec.description = "drop in replacement for the acme_plugin gem to add support for letsencrypt v2 api."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'acme-client', '~> 2.0.5'
  spec.add_dependency 'rails', ['>= 5.0', '< 7']

  spec.add_development_dependency "sqlite3"
end
