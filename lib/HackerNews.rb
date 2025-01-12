# frozen_string_literal: true

# Module for HackerNews utility classes
module HackerNews
  # Utility methods. Mainly used in controllers.
  class Utils
    # Gets a range of items from HN API, using threads. Returns a list of Items.
    # Currently does not save them to the DB.
    #
    # @param ids [Array<Integer>] A list of item IDs to request from HackerNews api.
    #
    # @return items [Array<HackerNewsItem>] A list of HackerNewsItem objects.
    def self.get_items_from_ids(ids)
      data = []
      threads = []
      ids.each_with_index do |id, i|
        threads << Thread.new do
          # item = HackerNews::Request.new.get(api: :hn, resource: :item, id:)
          item = HackerNewsRequestor.new(api: :hn, resource: :item, id:).call
          data[i] = item
        end
      end
      threads.each(&:join)

      # Map our items to actual HackerNewsItems
      # items.map! do |item_res_data|
      #   item = HackerNewsItem.new
      #   item.assign_attributes(item_res_data[:data])
      #   item
      # end
      # items
      items_from_data(data)
    end

    # Desctructively maps a list of items data hashes to a list of
    # HackerNewsItem's.
    #
    # @param data [Hash] of the form { code:, data: }
    #
    # @return data [Array<HackerNewsItem>] a list of HackerNewsItems.
    def self.items_from_data(data)
      data.map! do |res|
        item = HackerNewsItem.new
        item.assign_attributes(res[:data])
        item
      end
      data
    end

    # Ensures the p (params[:p]) value is present and convertible to an integer
    # within the expected range.
    #
    # @return [Integer] 1 if param invalid else p.to_i
    def self.normalized_page(p)
      if invalid_param_p? p
        1
      else
        p.to_i
      end
    end

    # Gives the range of items to display, based on the page requested from params[:p]
    #
    # @return [Range] the range from N .. (N + 30) - 1, where N is the page offset.
    def self.page_range
      (page - 1) * 30..(page * 30) - 1
    end

    # Computes the domain of the provided URL. Used in the display of the Item.
    #
    # @param url [String] The URL of an Item.
    #
    # @return [String] The computed domain.
    def self.url_domain(url)
      return "" if url.nil? || url.empty?

      # It appears that HN gives special treatment to github domains, e.g.
      # displaying github.com/vladm7 instead of just github.com, which implies an
      # internal whitelist and formatting to such things, but I won't worry about
      # that for now.
      uri = URI(url)
      "(#{PublicSuffix.parse(uri.hostname).domain})"
    end

    # Determines whether or not param_p is present and within the expected range.
    #
    # @param param_p [String] the raw params[:p] value from the request.
    #
    # @return [true] if param_p is considered valid.
    # @return [false] if param_p is invalid.
    def self.invalid_param_p?(param_p)
      param_p.nil? || param_p.empty? || (param_p.to_i > Constants::MAX_PAGES_OF_ITEMS || param_p.to_i < 1)
    end

    # Returns @page if defined, otherwise, defines it as 1.
    def self.page
      @page ||= 1
    end
  end
end
