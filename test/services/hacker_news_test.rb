# frozen_string_literal: true

require "minitest/autorun"

class HackerNewsTest < Minitest::Test
  def test__validate_and_set_uri
    resource = :maxitem
    assert_equal("https://hacker-news.firebaseio.com/v0/maxitem.json",
                 HackerNews._validate_and_set_uri(resource, {}))
  end

  def test_get_basic_resource_valid_params
    # Mock HTTParty::Response values used in HackerNews.get
    # There's probably a better way to do this...
    res = Minitest::Mock.new
    res.expect :code, 200
    res.expect :body, "12345"
    res.expect :get, 123_45
    HTTParty.stub :get, res do
      assert_equal HackerNews.get(resource: :maxitem), { code: 200, data: 123_45 }
    end
  end

  def test_get_parameterized_resource_valid_params
    res = Minitest::Mock.new
    res.expect :code, 200
    res.expect :body, "{\"key\":\"value\"}"
    res.expect :get, { "key" => "value " }
    HTTParty.stub :get, res do
      assert_equal HackerNews.get(resource: :item, id: 1), { code: 200, data: { key: "value" } }
    end
  end

  def test_get_invalid_resource
    assert_raises(HackerNews::ArgumentError, "Requested resource '/bad_resource' invalid.") do
      HackerNews.get(resource: :bad_resource)
    end
  end

  def test_get_valid_resource_invalid_options
    assert_raises(HackerNews::ArgumentError, "'/item' requires an :id.") { HackerNews.get(resource: :item) }
  end
end
