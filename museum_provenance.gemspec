# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'museum_provenance/version'

Gem::Specification.new do |spec|
  spec.name          = "museum_provenance"
  spec.version       = MuseumProvenance::VERSION
  spec.authors       = ["David Newbury"]
  spec.email         = ["david.newbury@gmail.com"]
  spec.summary       = %q{TODO: A little library for extracting structured data from museum provenance records.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = "http://museumprovenance.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
