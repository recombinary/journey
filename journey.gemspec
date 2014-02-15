# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'journey/version'

Gem::Specification.new do |spec|
  spec.name          = "journey"
  spec.version       = Journey::VERSION::STRING
  spec.authors       = ["Dan Davey"]
  spec.email         = ["dan@recombinary.com"]
  spec.description   = %q{Extends ActiveResource to provide a base for Journey resources, supporting all attribute types}
  spec.summary       = %q{Journey API wrapper for Ruby}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'active_attr', '~> 0.8.2'
  spec.add_runtime_dependency 'activeresource', '~> 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.1.1'
  spec.add_development_dependency 'rspec', '~> 3.0.0.beta1'
  spec.add_development_dependency 'pry', '~> 0.9.12.4'

end
