require_relative('../lib/contract_verifier/matchers/url_matcher.rb')
describe UrlMatcher do
  it "replace_placeholders_with_regex" do
    expected = /^\/discounts\/supplier\/([a-zA-Z0-9_.-]+)\/([a-zA-Z0-9_.-]+).json$/
    actual=UrlMatcher.replace_placeholders_with_regex("/discounts/supplier/{supplier_id}/{article_id}.json")
    expect(expected).to eq actual
  end

  it "match returns true for valid url and pattern " do
    actual=UrlMatcher.match?("/discounts/supplier/{supplier_id}/{article_id}.json","/discounts/supplier/1212/article_id.json")
    expect(true).to eq actual
  end

  it "match returns false for invalid url" do
    actual=UrlMatcher.match?("/discounts/supplier/{supplier_id}/{test}/{article_id}.json","/discounts/supplier/1212/article_id.json")
    expect(false).to eq actual
  end

  it "match returns false for invalid pattern" do
    actual=UrlMatcher.match?("/discounts/supplier/{supplier_id}/{article_id}.json","/discounts/supplier/1212/12121/article_id.json")
    expect(false).to eq actual
  end

end