require 'rspec/expectations'

RSpec::Matchers.define :verify_get_contract do |consumer_schema, consumer_data|
  match do |matcher|
    begin
      schema = JSON.parse(open(consumer_schema).read)['response']
      data = JSON.parse(open(consumer_data).read)
      JSON::Schema.validate(data, schema, {:additional_properties => false})
    rescue JSON::Schema::ValueError => e
      raise "please check files #{consumer_schema} and #{consumer_data} : #{e}"
    end
  end
end


RSpec::Matchers.define :verify_post_contract do |consumer_schema, consumer_data|
  match do |matcher|
    begin
      schema = JSON.parse(open(consumer_schema).read)['request'].first
      data = JSON.parse(open(consumer_data).read)
      JSON::Schema.validate(data, schema, {:additional_properties => {}})
    rescue JSON::Schema::ValueError
      puts "Error in request body".capitalize.bold.red
    end
  end
end
