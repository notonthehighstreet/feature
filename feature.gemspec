# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'feature/version'

Gem::Specification.new do |spec|
  spec.name          = "feature"
  spec.version       = Feature::VERSION
  spec.authors       = ["Alex Jahraus and Dan Hart"]
  spec.email         = ["alexanderjahraus+danhart@notonthehighstreet.com"]
  spec.summary       = %q{Features yo.}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
end
