require 'rspec'
require_relative 'utils'

module ContractSchemaValidator
  class Contract
    include Utils
    include RSpec::Matchers
    include RSpec::Core::Pending

    def initialize(stub_root, service_port)
      @stub_root = stub_root
      @service_port = service_port
    end


    GET = 'GET'
    POST = 'POST'

    def validate(entry)
      begin
        if entry['request']['file'].is_a?(Hash)
            entry['request']['file'].each do |key,value|
               validate_consumer_schema entry,value
            end
        else
          validate_consumer_schema entry, entry['request']['file']
        end

      rescue JSON::ParserError => e
        puts entry['request']['file'].bold.red
        puts e.backtrace
        raise e
      end
    end

    def validate_consumer_schema(entry, schema_file)
      consumer_schema = schema_file_name schema_file
      unless file_present? consumer_schema
        raise PendingDeclaredInExample.new("Schema Undefined")
      end
      provider_schema = construct_url_for(entry['request']['url'])
      should verify_response(consumer_schema, provider_schema)

      if entry['request']['method'] == POST
        should verify_request(consumer_schema, provider_schema)
      end
    end

    def construct_url_for(input_url)
      input_url = input_url.gsub('{','').gsub('}','')
      url_pattern_with_regex = /\[.*\]/
      if input_url.match(url_pattern_with_regex)
        head = url.split("/")[0...-1].join("/")
        input_url = "#{head}/path_param_substituted.json"
      end
      "http://localhost:#{@service_port}#{input_url}?_wadl"
    rescue => e
      puts "Invalid URL: #{input_url}".bold.red
      raise e
    end

  end
end
