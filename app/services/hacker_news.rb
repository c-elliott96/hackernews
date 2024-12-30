# frozen_string_literal: true

require "httparty"

# HackerNews service module
module HackerNews
  # NOTE: Using algolia requires attention to the number of requests being made.
  # There is a rate limit of 10,000 requests per hour per IP.
  # In the future, it may be wise to move the controller logic to the front-end,
  # so that the limit is applied to the client instead of the server.

  # Handles making requests to a given resource.
  class Request
    def get(api:, resource:, **options)
      # TODO: ensure valid params
      #       (:id should be valid, due to checks in
      #       ApplicationController)
      #
      # Sample for logging on invalid params Better way to handle this
      # gracefully? I would not expect the entire application to fail, but
      # perhaps the caller should be expected to handle an error emitted.
      #
      # unless RESOURCES.key?(resource) && valid_params?(resource, options)
      #   Rails.logger.tagged("HackerNews#get(:#{resource})") do
      #     Rails.logger.warn { "Requested resource '/#{resource}' options #{options} invalid." }
      #   end
      # end

      url = setup_uri(api, resource, options)
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

    # Determines which API we need to set up the URI for.
    # Might be better to use a hash of available APIs.
    def setup_uri(api, resource, options)
      api == :hn ? setup_hn_uri(resource, options) : setup_algolia_uri(resource, options)
    end

    # Sets up URI for request to HN
    def setup_hn_uri(resource, options)
      uri = "#{Constants::BASE_HN_URI}#{Constants::HN_RESOURCES[resource]}"
      uri << "/" unless options.empty?
      uri << options[:id].to_s if %i[item user].include? resource
      uri << ".json"
    end

    # Sets up URI for request to Algolia
    def setup_algolia_uri(resource, options)
      uri = "#{Constants::BASE_ALGOLIA_URI}#{Constants::ALGOLIA_RESOURCES[resource]}"
      if %i[items users].include?(resource)
        return uri << "/" << (resource == :items ? options[:id].to_s : options[:username].to_s)
      end

      # query_string = !options.nil? && URI.encode_www_form(options)
      query_string = !options.nil? && CGI.unescape(options.to_query)
      %i[search search_by_date query].include?(resource) ? uri << "?#{query_string}" : uri
    end
  end
end
