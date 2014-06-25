# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'contract_verifier/version'

Gem::Specification.new do |spec|
  spec.name = "contract_verifier"
  spec.version = ContractVerifier::VERSION
  spec.authors = ["GruppoPam"]
  spec.email = ["gruppopam@thoughtworks.com"]
  spec.summary = ["Contract verifier, verifies the contract against wadl as well as data against contract"]
  spec.description = ["Contract verifier, verifies the contract against wadl as well as data against contract"]
  spec.homepage = ""
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_development_dependency 'json'
  spec.add_development_dependency 'pry'

  spec.add_dependency 'json-compare'
  spec.add_dependency 'hashdiff'
  spec.add_dependency 'rails', '~> 4'
  spec.add_dependency 'colorize'
  spec.add_dependency 'rspec-rails', '~> 2.14.0'
  spec.add_dependency 'rspec-core'
  spec.add_dependency 'artii'
  spec.add_dependency 'rspec'


end
