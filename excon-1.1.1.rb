require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "excon", "1.1.1"
  gem "webmock"
  gem "minitest"
end

require "excon"
require "minitest/autorun"
require "webmock/minitest"

class TestExcon < Minitest::Test
  def test_query_string_match
    stub_request(:get, "http://example.com").with(query: { q: "a b"}).to_return(status: 200)
    assert_equal 200, Excon.get("http://example.com", query: "q=a+b").status
  end

  def test_header_match
    stub_request(:get, "https://example.com")
      .with(headers: {
        "accept" => "application/json",
        "host" => "example.com:443" })
      .to_return(status: 200)
    http = Excon.new("https://example.com",
      headers: { "accept" => "application/json" },
      middlewares: Excon.defaults[:middlewares])
    assert_equal 200, http.get.status
  end
end
