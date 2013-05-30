# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'planefinder/version'

Gem::Specification.new do |spec|
  spec.name          = "planefinder"
  spec.version       = Planefinder::VERSION
  spec.authors       = ["Dave Ceddia"]
  spec.email         = ["dceddia@gmail.com"]
  spec.description   = %q{Find airplanes for sale and search the results}
  spec.summary       = %q{Find airplanes for sale and search the results}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
