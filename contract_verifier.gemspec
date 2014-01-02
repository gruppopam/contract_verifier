# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contract_verifier/version'

Gem::Specification.new do |spec|
  spec.name          = "contract_verifier"
  spec.version       = ContractVerifier::VERSION
  spec.authors       = ["GruppoPam"]
  spec.email         = ["gruppopam@thoughtworks.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'json-compare'
  spec.add_development_dependency 'json'
  spec.add_development_dependency 'rails', '~> 3.2'
  spec.add_development_dependency 'rspec-rails', '~> 2.10.1'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'hashdiff'
  spec.add_development_dependency 'colorize'
end
