require_relative 'utils'

module StubSchemaValidator
  class StubVerifier
    include ContractVerifier::Utils
    include RSpec::Matchers
    include RSpec::Core::Pending

    def initialize(stub_root, data_root)
      @stub_root = stub_root
      @data_root = data_root
    end

    def validate(entry)
      begin
        if entry['request']['method'] == 'GET'
          unless entry['response']['file']
            raise PendingDeclaredInExample.new("Data files Undefined")
          end
          consumer_schema = schema_file_name entry['response']['schema']
          unless file_present? consumer_schema
            raise "Schema Undefined/File not present - #{consumer_schema}"
          end
          consumer_data = data_file_name entry['response']['file']
          should verify_get_contract(consumer_schema, consumer_data)
        else
          raise PendingDeclaredInExample.new("POST/PUT/DELETE yet to be handled")
        end
      end
    end
  end
end
