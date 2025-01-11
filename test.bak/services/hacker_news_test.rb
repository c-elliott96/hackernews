# frozen_string_literal: true

require "minitest/autorun"

class HackerNewsTest < Minitest::Test
  def test__validate_and_set_uri
    resource = :maxitem
    assert_equal("https://hacker-news.firebaseio.com/v0/maxitem.json",
                 HackerNews._validate_and_set_uri(resource, {}))
  end

  def test_get_basic_resource_valid_params
    res = Minitest::Mock.new
    res.expect :code, 200
    res.expect :body, "12345"
    res.expect :get, 123_45
    res.expect :[], :a_res_body, [:body] # Mock #[] on res, make it respond with something truthy, expect res[:body] use
    res.expect :body, "12345" # We have to mock this again because the method is getting called again? Smells bad.
    HTTParty.stub :get, res do
      assert_equal HackerNews.get(resource: :maxitem), { code: 200, data: 123_45 }
    end
  end

  def test_get_parameterized_resource_valid_params
    res = Minitest::Mock.new
    res.expect :code, 200
    res.expect :body, "{\"key\":\"value\"}"
    res.expect :get, { "key" => "value " }
    res.expect :[], :a_res_body, [:body]
    res.expect :body, "{\"key\":\"value\"}"
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

  def test_logger_warns_on_invalid_id
    # TODO: validate logger logic in HackerNews#get
  end
end
