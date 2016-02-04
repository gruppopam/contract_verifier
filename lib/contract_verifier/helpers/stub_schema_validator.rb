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
        key = 'response'
        consumer_data = data_file_name_for(entry, key)
        consumer_schema = schema_file_name(entry, key)
        expect verify_contract(consumer_schema, consumer_data, key) unless (consumer_schema.nil? or consumer_data.nil?)

        unless entry['request']['method'] == 'GET'
          key = 'request'
          consumer_data = data_file_name_for(entry, key)
          consumer_schema = schema_file_name(entry, key)
          expect verify_contract(consumer_schema, consumer_data, key) unless (consumer_schema.nil? or consumer_data.nil?)
        end

        return true if consumer_data.nil?
        return true if entry['request']['url_has_regex']

        actual_file_url = entry['request']['url'].gsub('$','').gsub('^','')
        actual_file_url.expect match_url_in_schema consumer_schema

      end

    end

  end
end


