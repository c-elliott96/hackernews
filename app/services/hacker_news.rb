# frozen_string_literal: true

require "httparty"

# Handles HackerNews API (v0) requests, with custom Errors
#
# Usage: HackerNews.get(resource: {RESOURCES_SYM}, [id: ID])
# Returns JSON response as a hash of the form
# {
#   code: RESPONSE CODE,
#   data: HASH OF DATA
# }
module HackerNews
  class Error < StandardError; end
  class ArgumentError < Error; end

  # v0 API uri
  ::BASE_URI = "https://hacker-news.firebaseio.com/v0"

  # v0 available resources
  ::RESOURCES = {
    item: "item",
    user: "user",
    maxitem: "maxitem",
    top_stories: "topstories",
    new_stories: "newstories",
    best_stories: "beststories",
    ask_stories: "askstories",
    show_stories: "showstories",
    job_stories: "jobstories"
  }.freeze

  # Makes GET request after validating params. Returns a hash containing the
  # response :code with hash called :data that contains JSON of the response body
  def self.get(resource:, **options)
    uri = _validate_and_set_uri(resource, options)
    res = HTTParty.get uri

    # NOTE: requesting an item with an id that doesn't exist, i.e. item.id >
    # maxitem, still returns a 200 response code.
    # So, until I think of a better way to handle this scenario, I just warn if
    # the body of the response is nil.
    Rails.logger.tagged("HackerNews.get") do
      Rails.logger.warn "Requested resource #{resource} appears invalid." if res[:body].nil?
    end

    # Normalize response
    {
      code: res.code,
      data: JSON.parse(res.body, { symbolize_names: true })
    }
  end

  # Validates params passed to .get. Returns uri
  def self._validate_and_set_uri(resource, options)
    raise ArgumentError, "Requested resource '/#{resource}' invalid." unless RESOURCES.key? resource

    uri = +"#{BASE_URI}/#{RESOURCES[resource]}"
    if %i[item user].include? resource
      raise ArgumentError, "'/#{resource}' requires an :id." unless options.key? :id

      uri << "/#{options[:id]}"
    end

    # Setting 'Accept: application/json' header does not achieve the same
    # response as requesting JSON explicitly. I haven't been able to figure out
    # a better way to do this.
    uri << ".json"
  end
end
