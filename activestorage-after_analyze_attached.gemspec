require_relative "lib/activestorage/after_analyze_attached/version"

Gem::Specification.new do |spec|
  spec.name        = "activestorage-after_analyze_attached"
  spec.version     = Activestorage::AfterAnalyzeAttached::VERSION
  spec.authors     = [ "Syed Fazil Basheer" ]
  spec.email       = [ "fazil@fazn.co" ]
  spec.homepage    = "https://github.com/frayzil/activestorage-after_analyze_attached"
  spec.summary     = "Adds after_analyze callback to ActiveStorage attachments"
  spec.description = "This gem extends ActiveStorage to provide an after_analyze callback that gets triggered after analyzing an attachment"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/frayzil/activestorage-after_analyze_attached"
  spec.metadata["changelog_uri"] = "https://github.com/frayzil/activestorage-after_analyze_attached/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.1"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
end
