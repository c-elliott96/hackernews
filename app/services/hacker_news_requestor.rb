# frozen_string_literal: true

require "httparty"

# Makes GET request for specific HackerNews data APIs. For now, these APIs are
# HackerNews and Algolia.
class HackerNewsRequestor
  attr_reader :api, :resource, :options

  # Initializes the Requestor
  #
  # @param api [Symbol] the specific API to request from (HackerNews; Algolia)
  # @param resource [Symbol] the resource to request from the API
  # @param [Hash] options The options for certain types of requests
  # @option options [Symbol] :id The ID of an Item or User. Applies to
  #   HackerNews Item or User resources, and Algolia Items or Users resources.
  def initialize(api:, resource:, **options)
    @api = api
    @resource = resource
    @options = options
  end

  # Makes the HTTP request for HN data
  #
  # @return [Hash{Symbol=>Numeric, Symbol=>Hash}]
  #
  def call
    url = create_uri
    Rails.logger.info { "Requesting #{url}" }
    res = HTTParty.get(url)

    parsed_body = JSON.parse(res.body, { symbolize_names: true })

    # Normalize response
    {
      code: res.code,
      data: parsed_body
    }
  end

  private

  # Creates the URI based on whether the request is for HN or Algolia (depends
  # on @api)
  #
  # @return [String]
  #
  def create_uri
    api == :hn ? hn_uri : algolia_uri
  end

  # Creates URI for request to HN
  #
  # @return [String]
  #
  def hn_uri
    uri = "#{Constants::BASE_HN_URI}#{Constants::HN_RESOURCES[@resource]}"
    uri << "/" unless @options.empty?
    uri << @options[:id].to_s if %i[item user].include? @resource
    uri << ".json"
  end

  # Creates URI for request to Algolia
  #
  # @return [String]
  #
  def algolia_uri
    uri = "#{Constants::BASE_ALGOLIA_URI}#{Constants::ALGOLIA_RESOURCES[@resource]}"
    return uri << algolia_items_or_users_uri if %i[items users].include?(@resource)

    query_string = !options.nil? && CGI.unescape(options.to_query)
    %i[search search_by_date query].include?(resource) ? uri << "?#{query_string}" : uri
  end

  # Adds required params to URI for Algolia :items or :users resources.
  # @return [String]
  def algolia_items_or_users_uri
    "/#{@resource == :items ? @options[:id].to_s : @options[:username].to_s}"
  end
end
