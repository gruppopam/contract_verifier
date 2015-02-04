module UrlMatcher 
  extend self
  

  def match? pattern,url
    regex_pattern = replace_placeholders_with_regex pattern
    matches = regex_pattern.match(url)
    return false if matches.nil?
    return url.eql? matches[0]
  end

  def replace_placeholders_with_regex(pattern)
    place_holders=pattern.scan(/\{(.*?)\}/)
    place_holders.each do |place_holder|
      pattern.sub!("{#{place_holder[0]}}",'([a-zA-Z0-9_.-]+)')
    end
    return /^#{pattern}$/
  end

end
