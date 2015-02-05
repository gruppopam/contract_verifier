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
          url = "http://localhost:#{service_port}#{context}/?_wadl"
          full_schema = JSON.parse(Net::HTTP.get(URI(url)))
          service_entries=YAML.load_file(yaml_file)
          handle_for_resource(context, contract, full_schema, service_entries, yaml_file)
          handle_removed_end_points(service_entries)
        rescue Errno::ECONNREFUSED => e
          puts red("Service is not running in the port #{service_port}".capitalize)
          raise e
        end


        def validate_stub_for(opts)
          stub_root = opts[:stub_root]
          data_root = opts[:data_root]
          yaml_file = data_root +'/'+ opts[:yml_file]
          contract = StubSchemaValidator::StubVerifier.new(stub_root, data_root)
          service_entries=YAML.load_file(yaml_file)
          service_entries.each do |entry|
            it("Stub schema verifier for #{opts[:yml_file]} -- #{entry['request']['url']}") do
              contract.validate entry
            end
          end
        end


        private

        def handle_for_resource(context, contract, full_schema, service_entries, yaml_file)
          base_path = URI.parse(full_schema['base_url']).request_uri.gsub(/\/+/, '/')
          base_path = '/' + base_path unless base_path.empty?
          base_path = "#{base_path}/" unless base_path.end_with? '/'
          full_schema['resources'].each do |resource|
            get_url = (base_path + resource['resource']['path'])
            entry = service_entries.select do |key, hash|
              key["request"]["url"].gsub(/\/+/, '/') == get_url.gsub(/\/+/, '/') and key["request"]["method"] == resource["resource"]["method"]
            end
            if entry.length > 1
              it 'Multiple declaration Found' do
                fail "For request pattern : #{entry.first['request']['url']} in #{yaml_file}"
              end
              next
            elsif entry.empty?
              it 'Resource not defined ' do
                fail("for: #{get_url} in #{yaml_file}")
              end
              next
            elsif entry.first['request']['exclude']
              it 'Excluding resource' do
                pending("excluding : #{get_url} in #{yaml_file}")
              end
              entry.first['in_wadl'] = true
              next
            end
            entry = entry.first
            it("Contract test for #{entry['request']['url']}") do
              contract.validate entry, context
            end
            entry['in_wadl'] = true
          end
        end

        def handle_removed_end_points(service_entries)
          service_entries.each do |entry|
            unless entry.has_key?('in_wadl')
              it "service removed" do
                fail("Service removed #{entry['request']}")
              end
            end
          end
        end

      end
    end
  end
end
RSpec::Core::ExampleGroup.extend(ContractVerifier::RSpec::ContractMatcher::ClassMethods)
