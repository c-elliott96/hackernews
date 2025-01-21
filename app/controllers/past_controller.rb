# frozen_string_literal: true

# Gets a list of posts from a given date, sorted by some ranking.
#
# `/front`, on HN.
class PastController < ApplicationController
  # Retrieves historical stories, sorted from oldest to newest, based on the
  # date. Utilizes Algolia /search_by_date. If pagination exceeds available
  # results, renders this controller action and resets pagination.
  #
  # @param date [String] (optional) Provided via params[:date], the date to get
  #   stories for. Defaults to one day ago.
  #
  # @param page [String] (optional) Provided via params[:p], the page of results
  #   to display. Defaults to 1, but we actually use p - 1, as Algolia's
  #   pagination is 0-indexed.
  def index
    @date = date
    @page = page
    @algolia_page = algolia_page
    data = HackerNewsRequestor.new(api: :algolia, resource: :search_by_date, **opts)
                              .call[:data][:hits]

    # case where the user has requested "More" and there are no stories left to
    # show. Redirect back to this action and reset pagination.
    redirect_to past_url and return if data.nil?

    # Reverse the order of the data. See #algolia_page for explanation.
    data.reverse!

    # Make our AlgoliaSearchByDateItem's
    @items = []
    setup_items(data)
  end

  private

  def opts(page: @algolia_page)
    # Start date time Unix
    created_at_i = @date.to_time.to_i
    # End date time Unix
    # TODO: needs to support params[:day].
    ends_at_i = Time.now.to_i
    # Set up the options: filter on stories, set the time range, request 30 results, request a specific page
    {
      tags: :story,
      numericFilters: "created_at_i>#{created_at_i},created_at_i<#{ends_at_i},points>2",
      hitsPerPage: 30,
      page: page
    }
  end

  def date
    if params[:day].blank?
      # Date.yesterday
      1.day.ago
    else
      # TODO: Parse/normalize params[:day]
      params[:day]
    end
  end

  def page
    if params[:p].blank?
      1
    else
      params[:p].to_i
    end
  end

  def algolia_page
    # First, query the API and store the res. Shortly, we extract the :nbPages and :nbHits fields.
    # The reason for this is:
    #
    #   Suppose there are 525 hits. This number is not divisible by 30 (the
    #   current MAX_ITEMS_PER_PAGE). To avoid complicated logic around splitting
    #   the index items into multiple pages from Algolia, we just ignore the
    #   page with the remaining hits. We do discard some data that /should/ be
    #   displayed, but it appears HackerNews itself does not display all of the
    #   items in the date range. How it determines what items to display in its
    #   index is not clear. To help reduce the number of results, we also filter
    #   by points, >2.
    #
    #   If, by luck, the number of hits /is/ divisible by MAX_ITEMS_PER_PAGE, we
    #   can display the full number of pages.
    res = HackerNewsRequestor.new(api: :algolia, resource: :search_by_date, **opts(page: @page))
                             .call[:data]
    num_pages = res[:nbPages]

    # Algolia :search_by_date resource returns results from newest to oldest. It
    # does not seem to support ordering the response in any other way.
    # HackerNews, however, displays the results from oldest to newest. So,
    #
    # num_pages is the total number of pages, where the results are from newest
    # to oldest. We actually want to display them in the reverse order, so, we
    # need to wrap around the number of pages in reverse order, i.e. @page = 0
    # => num_pages, @page = 1 => num_pages - 1, ...

    # If we can split up the total hits evenly into pages without merging
    # multiple requests, great. Otherwise, we simply discard the oldest page of
    # results that is < MAX_ITEMS_PER_PAGE in length.
    total_hits_divisible_by_items_per_page = (res[:nbHits] % Constants::MAX_ITEMS_PER_PAGE).zero?
    total_hits_divisible_by_items_per_page ? num_pages - @page : num_pages - @page - 1
  end

  def setup_items(data)
    data.each_with_index do |item, idx|
      new_item = AlgoliaSearchByDateItem.new(item)
      new_item.rank = rank(idx)
      @items.append(new_item)
    end
  end

  def rank(idx)
    ((@page - 1) * 30) + idx + 1
  end
end
