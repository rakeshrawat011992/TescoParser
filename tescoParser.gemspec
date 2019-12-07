lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tescoParser/version"

Gem::Specification.new do |spec|
  spec.name          = "tescoParser"
  spec.version       = TescoParser::VERSION
  spec.authors       = ["rakeshrawat011992"]
  spec.email         = ["rakeshrawat011992@gmail.com"]

  spec.summary       = "This gem Parse the data for Tesco bill"
  spec.description   = "uses input as OCR data and gives data in store data model form"
  spec.homepage      = "https://github.com/rakeshrawat011992/TescoParser"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rakeshrawat011992/TescoParser"
  spec.metadata["changelog_uri"] = "https://github.com/rakeshrawat011992/TescoParser"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
