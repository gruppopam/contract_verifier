require "contract_verifier/version"

module ContractVerifier
  module RSpec
    module ContractMatcher
      module ClassMethods
        def validate_contract_for(opts)
          stub_root = opts[:stub_root]
          yaml_file = stub_root +'/'+ opts[:yml_file]
          contract = ContractSchemaValidator::Contract.new(stub_root, opts[:service_port])
          service_entries=YAML.load_file(yaml_file)
          service_entries.each do |entry|
            it("Contract test for #{stub_root} -- #{entry['request']['url']}") do
              contract.validate entry
            end
          end
        end

        def validate_stub_for(opts)
          stub_root = opts[:stub_root]
          yaml_file = stub_root +'/'+ opts[:yml_file]
          contract = StubSchemaValidator::StubVerifier.new(stub_root)
          service_entries=YAML.load_file(yaml_file)
          service_entries.each do |entry|
            it("Stub schema verifier for #{opts[:yml_file]} -- #{entry['request']['url']}") do
              contract.validate entry, 'GET'
            end
          end
        end
      end
    end
  end
end
RSpec::Core::ExampleGroup.extend(ContractVerifier::RSpec::ContractMatcher::ClassMethods)
