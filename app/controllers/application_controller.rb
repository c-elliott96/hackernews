# frozen_string_literal: true

# Base application controller. All other controllers typically extend
# ApplicationController.
class ApplicationController < ActionController::Base
  # For all of the controller "show" actions, we will use the Algolia API. This
  # is because the Algolia "/items" resource returns all of the child items at
  # once. For the case of the "index" actions, the we have to use the HackerNews
  # API for all but two view types: the "past" view and the "comments" view,
  # which need to make use of Algolia's "/search_by_date" resource.
  #
  # /topstories, /newstores, /beststories give us 500 stories. We display
  # 30 stories per page.
  # TODO: Add Yard annotations

  def get_items_from_ids(ids) # rubocop:disable Metrics/MethodLength
    # Gets a range of items from HN API, using threads. Returns a list of Items.
    # Currently does not save them to the DB.
    items = []
    threads = []
    ids.each_with_index do |id, i|
      threads << Thread.new do
        # item = HackerNews::Request.new.get(api: :hn, resource: :item, id:)
        item = HackerNewsRequestor.new(api: :hn, resource: :item, id:).call
        items[i] = item
      end
    end
    threads.each(&:join)

    # Map our items to actual HackerNewsItems
    items.map! do |item_res_data|
      item = HackerNewsItem.new
      item.assign_attributes(item_res_data[:data])
      item
    end
    items
  end

  def normalized_page
    if invalid_param_p? params[:p]
      1
    else
      params[:p].to_i
    end
  end

  def invalid_param_p?(param_p)
    param_p.nil? || param_p.empty? || (param_p.to_i > Constants::MAX_PAGES_OF_ITEMS || param_p.to_i < 1)
  end

  def page_range
    (@page - 1) * 30..(@page * 30) - 1
  end

  def url_domain(url)
    return "" if url.nil? || url.empty?

    # It appears that HN gives special treatment to github domains, e.g.
    # displaying github.com/vladm7 instead of just github.com, which implies an
    # internal whitelist and formatting to such things, but I won't worry about
    # that for now.
    uri = URI(url)
    "(#{PublicSuffix.parse(uri.hostname).domain})"
  end

  def score_string(score, by)
    return "" unless !score.nil? || !score.empty? || score.zero?

    point_or_points = score == 1 ? "point" : "points"
    "#{score} #{point_or_points} by #{by}"
  end
end
