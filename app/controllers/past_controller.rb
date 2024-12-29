# frozen_string_literal: true

# Gets a list of posts from a given date, sorted by some ranking.
#
# `/front`, on HN.
class PastController < ApplicationController
  # Allowed params: day (defaults to yesterday), p (pagination)
  def index
    # We need to query Algolia API to get items "type:story", with a date that corresponds to the given date range.
    # For now, just display the paginated results as-is. Maybe worry about ordering them later.
    # Date defaults to yesterday on HN.
    @date =
      if params[:day].blank?
        Date.yesterday
      else
        params[:day]
      end

    @page =
      if params[:page].blank?
        0
      else
        params[:page].to_i
      end

    # Start date time Unix
    created_at_i = @date.to_time.to_i
    # End date time Unix
    ends_at_i = Time.now.to_i
    # Set up the options: filter on stories, set the time range, request 30 results, request a specific page
    opts = {
      tags: :story,
      numericFilters: "created_at_i>#{created_at_i},created_at_i<#{ends_at_i}",
      hitsPerPage: 30,
      page: @page
    }

    @items = []
    setup_items(HackerNews::Request.new.get(api: :algolia, resource: :search_by_date, **opts)[:data])

    # TODO: Set up the pages in reverse order. Might require two Algolia calls
    # First to get the num of pages and the second to get the results of the
    # computed page.
  end

  private

  def setup_items(data)
    data[:hits].each_with_index do |item, idx|
      @items.append(
        AlgoliaItem.new(
          author: item[:author],
          created_at: item[:created_at],
          created_at_i: item[:created_at_i],
          id: item[:objectID],
          points: item[:points],
          text: item[:story_text],
          title: item[:title],
          type: item[:type],
          url: item[:url],
          link_domain_name: url_domain(item[:url]),
          score_string: item[:points] ? score_string(item[:points], item[:author]) : nil,
          comment_string: nil,
          num_comments: item[:num_comments],
          rank: (@page * 30) + idx + 1
        )
      )
    end
  end
end
