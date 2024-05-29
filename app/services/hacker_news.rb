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

  # Makes get request after validating params
  # Returns HTTParty::Response
  # Service consumer responsible for handling responses
  def self.get(resource:, **options)
    uri = _validate_and_set_uri(resource, options)
    res = HTTParty.get uri

    # TODO: Fix this so e.g. resource: :item, id: ID > MAXITEM does NOT return a 200
    # because this item does not actually exist
    # A bad request looks to get a 301 code. HTTParty must be following by default
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
    uri << ".json"
  end
end
