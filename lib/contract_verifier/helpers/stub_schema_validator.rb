require_relative 'utils'
require_relative '../matchers/url_matcher'

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
        key = entry['request']['method'] == 'GET' ? 'response' : 'request'
        consumer_data = data_file_name_for(entry, key)
        consumer_schema = schema_file_name(entry, key)
        should verify_contract(consumer_schema, consumer_data, key) unless consumer_schema.nil?
      end
    end
  end
end


