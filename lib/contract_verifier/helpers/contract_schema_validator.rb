require_relative 'utils'

module ContractSchemaValidator
  class Contract
    include ContractVerifier::Utils
    include ::RSpec::Matchers
    include ::RSpec::Core::Pending

    def initialize(stub_root, service_port)
      @stub_root = stub_root
      @service_port = service_port
    end

    GET = 'GET'
    POST = 'POST'
    PUT = 'PUT'

    def validate(entry, context)
      begin
        if entry['request']['file'].is_a?(Hash)
          entry['request']['file'].each do |key, value|
            validate_consumer_schema entry, value
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
      consumer_schema = schema_name schema_file
      unless file_present? consumer_schema
        raise SkipDeclaredInExample.new("Schema Undefined")
      end
      provider_schema = construct_path_for(entry['request']['url'])
      http_method = entry['request']['method']
      should verify_response(consumer_schema, provider_schema, http_method, @service_port)

      if http_method == POST || http_method == PUT
        should verify_request(consumer_schema, provider_schema, http_method, @service_port)
      end
      expect("#{JSON.parse(open(consumer_schema).read)['path']}").to eq (entry['request']['url'])
    end

    def construct_path_for(input_url)
      input_url = input_url.gsub('{', '').gsub('}', '')
      url_pattern_with_regex = /\[.*\]/
      if input_url.match(url_pattern_with_regex)
        head = url.split("/")[0...-1].join("/")
        input_url = "#{head}/path_param_substituted.json"
      end
      "#{input_url}?_wadl"
    rescue => e
      puts "Invalid URL: #{input_url}".bold.red
      raise e
    end
  end
end
