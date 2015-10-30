require 'rspec/expectations'
require 'hashdiff'

RSpec::Matchers.define :verify_response do |consumer_schema, provider_schema, http_method, service_port|
  result = nil
  match do |matcher|
    request_body = create_request(service_port, http_method, provider_schema)
    provider_json = JSON.parse(request_body)['response']
    consumer_json = JSON.parse(open(consumer_schema).read)['response']
    diff =HashDiff.best_diff(provider_json, consumer_json)
    result = check_errors(diff)
    result.blank?
  end
  failure_message do |actual|
    error_message(provider_schema, consumer_schema, result)
  end
end

RSpec::Matchers.define :verify_request do |consumer_schema, provider_schema, http_method, service_port|
  result = nil
  match do |matcher|
    request_body = create_request(service_port, http_method, provider_schema)
    provider_json = JSON.parse(request_body)['request']
    consumer_json = JSON.parse(open(consumer_schema).read)['request']
    diff =HashDiff.best_diff(provider_json, consumer_json)
    result = check_errors(diff)
    result.blank?
  end

  failure_message do |actual|
    error_message(provider_schema, consumer_schema, result)
  end
end

private

def error_message(provider_schema, consumer_schema, result)
  error_prefix = "The following end point: #{provider_schema} and please check file #{consumer_schema} failed for reason(s):"
  result.collect do |differences|
    if differences[0] == '+'
      field_name = differences[1].partition('properties.').last
      " #{error_prefix}  The field #{field_name} is missing in provider contract"
    else
      field_name = differences[1]
      provider_field_type = differences[2].is_a?(Hash) ? differences[2]['type'] : differences[2]
      consumer_field_type = differences[3].is_a?(Hash) ? differences[3]['type'] : differences[3]
      "#{error_prefix}   Mismatch in field #{field_name} of type #{provider_field_type} in provider and type #{consumer_field_type} in consumer"
    end
  end
end

def check_errors(array)
  array.reject do |x|
    match_properties = x[1].match('items.properties./[a-z_]+/.')
    x.first == '-' && !match_properties.present?
  end
end

def create_request(service_port, http_method, path)
  http = Net::HTTP.new('localhost', service_port)
  http.send_request(http_method.upcase, path).body

rescue Errno::ECONNREFUSED => e
  puts red("Invalid end point : http://localhost:#{service_port}#{path}")
  raise e
end

