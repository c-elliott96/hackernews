# frozen_string_literal: true

require 'httparty'

# Handles HackerNews API (v0) requests, with custom Errors
#
# Usage: HackerNews.get(resource: {RESOURCES_SYM}, [id: ID])
# Returns JSON response as a hash
module HackerNews
  class Error < StandardError; end
  class ArgumentError < Error; end

  # v0 API uri
  ::BASE_URI = 'https://hacker-news.firebaseio.com/v0'

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

  #  Makes get request after validating params
  def self.get(resource:, **options)
    uri = _validate_and_set_uri(resource, options)
    res = HTTParty.get(uri)
    case res.code
    when 200
      res.parsed_response
    when 500...600
      puts "Error in request: #{res.code}"
    end
  end

  # Validates params passed to .get
  def self._validate_and_set_uri(resource, options)
    uri = BASE_URI + "/#{RESOURCES[resource]}"
    if %i[item user].include? resource
      raise ArgumentError, "'/#{resource}' requires an :id." unless options.key? :id

      uri << "/#{options[:id]}"
    elsif !RESOURCES.key?(resource)
      raise ArgumentError, "Requested resource '/#{resource}' invalid."
    end
    uri << '.json'
  end
end
