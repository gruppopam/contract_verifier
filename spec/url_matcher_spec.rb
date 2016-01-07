require_relative('../lib/contract_verifier/matchers/url_matcher.rb')
describe Url do
  it "replace_placeholders_with_regex" do
    pattern='([a-zA-Z0-9_.-]+|\[0\-9\]\+|\([a-zA-Z0-9|]+\))'
    expected = Regexp.new "^/discounts/supplier/#{pattern}/#{pattern}.json$"
    actual=Url.replace_placeholders_with_regex("/discounts/supplier/{supplier_id}/{article_id}.json")
    expect(expected).to eq actual
  end

  it "match returns true for valid url and pattern " do
    actual=Url.match?("/discounts/supplier/{supplier_id}/{article_id}.json","/discounts/supplier/1212/article_id.json")
    expect(true).to eq actual
  end

  it "match returns true for valid url with regex and pattern " do
    actual=Url.match?("/discounts/supplier/{supplier_id}/{article_id}.json","/discounts/supplier/[0-9]+/(1234|5678).json")
    expect(true).to eq actual
  end

  it "match returns false for invalid url" do
    actual=Url.match?("/discounts/supplier/{supplier_id}/{test}/{article_id}.json","/discounts/supplier/1212/article_id.json")
    expect(false).to eq actual
  end

  it "match returns false for invalid pattern" do
    actual=Url.match?("/discounts/supplier/{supplier_id}/{article_id}.json","/discounts/supplier/1212/12121/article_id.json")
    expect(false).to eq actual
  end

end