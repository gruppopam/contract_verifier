require 'rspec/expectations'
include ContractVerifier::Utils

RSpec::Matchers.define :verify_contract do |consumer_schema, consumer_data, key|
  match do |_|
    begin
      schema = JSON.parse(open(consumer_schema).read)[key]
      file_present?(consumer_data.to_s) ? data = JSON.parse(open(consumer_data).read) : data = consumer_data
      JSON::Schema.validate(data, schema, {:additional_properties => false})
    rescue JSON::Schema::ValueError => e
      raise "please check files #{consumer_schema} and #{consumer_data} : #{e}"
    end
  end
end

