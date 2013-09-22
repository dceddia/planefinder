# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'planefinder/version'

Gem::Specification.new do |spec|
  spec.name          = "planefinder"
  spec.version       = Planefinder::VERSION
  spec.authors       = ["Dave Ceddia"]
  spec.email         = ["dceddia@gmail.com"]
  spec.description   = %q{Find airplanes for sale and their approximate locations}
  spec.summary       = %q{Find airplanes for sale and narrow results by location}
  spec.homepage      = "https://github.com/dceddia/planefinder"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "geokit"
  spec.add_dependency "sequel"
  spec.add_dependency "sqlite3"
  
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fakeweb"
end
