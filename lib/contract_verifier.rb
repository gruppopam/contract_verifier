require "contract_verifier/version"
Dir[File.join(File.dirname(__FILE__), "contract_verifier/helpers/*.rb")].each { |file| require file }
Dir[File.join(File.dirname(__FILE__), "contract_verifier/matchers/*.rb")].sort!.each { |file| require file }

module ContractVerifier
  module RSpec
    module ContractMatcher
      module ClassMethods

        include Utils

        def validate_contract_for_yml(opts)
          stub_root = opts[:stub_root]
          context = opts[:context_path]
          yaml_file = stub_root +'/'+ opts[:yml_file]
          service_port = opts[:service_port]
          contract = ContractSchemaValidator::Contract.new(stub_root, service_port)
          url ||= "http://localhost:#{service_port}/#{context}/?_wadl"
          full_schema ||= JSON.parse(Net::HTTP.get(URI(url)))
          service_entries=YAML.load_file(yaml_file)
          full_schema['resources'].each do |resource|
            get_url = (full_schema['base_url'] + resource['resource']['path']).gsub("http://localhost:9090", '')
            entry = service_entries.select do |key, hash|
              key["request"]["url"] == get_url
            end
            entry = entry.first
            it("Contract test for #{stub_root} -- #{entry['request']['url']}") do
              contract.validate entry
            end
            entry['in_wadl'] = true
          end
          service_entries.each do |entry|
            unless entry.has_key?('in_wadl')
              puts yellow("Service removed #{entry['request']}")
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
