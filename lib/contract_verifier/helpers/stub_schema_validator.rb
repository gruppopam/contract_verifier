require_relative 'utils'
module StubSchemaValidator
  class StubVerifier
    include Utils
    include RSpec::Matchers
    include RSpec::Core::Pending

    def initialize(stub_root)
     @stub_root = stub_root
    end

    def validate(entry, http_verb)
      begin
        if entry['request']['method'] == http_verb
          return unless entry['response']['file']
          consumer_schema = schema_file_name entry['response']['file']
          unless file_present? consumer_schema
            raise PendingDeclaredInExample.new("Schema Undefined")
          end
          consumer_data = data_file_name entry['response']['file']
          should verify_get_contract(consumer_schema, consumer_data)
        end
      end
    end
  end
end
