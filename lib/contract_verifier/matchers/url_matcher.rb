require 'rspec/expectations'
module Url
  extend self

  RSpec::Matchers.define :match_url_in_schema do |consumer_schema|
    schema_url = JSON.parse(open(consumer_schema).read)['path']
    match do |actual|
      Url.match? schema_url, actual
    end

    failure_message do |actual|
      "expected url #{actual} does not match schema url #{schema_url}. Update schema file in #{consumer_schema}"
    end

  end

  def match? pattern,url
    regex_pattern = replace_placeholders_with_regex pattern
    matches = regex_pattern.match(url)
    return false if matches.nil?
    return url.eql? matches[0]
  end

  def replace_placeholders_with_regex(pattern)
    place_holders=pattern.scan(/\{(.*?)\}/)
    place_holders.each do |place_holder|
      pattern.sub!("{#{place_holder[0]}}",'([a-zA-Z0-9_.,-]+|\[0\-9[\-\,]*\]\\\+|\([a-zA-Z0-9|]+\))')
    end
    return /^#{pattern}$/
  end

end


