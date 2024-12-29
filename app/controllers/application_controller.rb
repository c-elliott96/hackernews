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
  ITEMS_PER_PAGE = 30
  TOTAL_PAGES = 16

  def get_item_from_id(id) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    item = HackerNews::Request.new.get(api: :hn, resource: :item, id:)
    Item.new do |i|
      i.hn_id       = item[:data][:id]
      i.deleted     = item[:data][:deleted]
      i.by          = item[:data][:by]
      i.time        = item[:data][:time]
      i.text        = item[:data][:text]
      i.dead        = item[:data][:dead]
      i.parent      = item[:data][:parent]
      i.poll        = item[:data][:poll]
      i.url         = item[:data][:url]
      i.score       = item[:data][:score]
      i.title       = item[:data][:title]
      i.kids        = item[:data][:kids]
      i.parts       = item[:data][:parts]
      i.descendants = item[:data][:descendants]
      i.context     = item[:data][:type]
    end
  end

  def get_items_from_ids(ids) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    # Gets a range of items from HN API, using threads. Returns a list of Items.
    # Currently does not save them to the DB.
    #
    # TODO: DB optimization.
    #   We will need to
    #       1. Check what items in the list of ids we have in the DB. Get them.
    #       2. Create threads to get the ones we don't.
    #       3. Save new items to the DB.
    #       4. Recombine the lists to return all items.
    items = []
    threads = []
    ids.each_with_index do |id, i|
      threads << Thread.new do
        item = HackerNews::Request.new.get(api: :hn, resource: :item, id:)
        items[i] = item
      end
    end
    threads.each(&:join)
    # Here, we create Item objects for all the items. This ensures consistent
    # object types to consume. Later, we can use this to save things to the DB
    # if we want.
    items.map! do |item|
      Item.new do |i|
        i.hn_id       = item[:data][:id]
        i.deleted     = item[:data][:deleted]
        i.by          = item[:data][:by]
        i.time        = item[:data][:time]
        i.text        = item[:data][:text]
        i.dead        = item[:data][:dead]
        i.parent      = item[:data][:parent]
        i.poll        = item[:data][:poll]
        i.url         = item[:data][:url]
        i.score       = item[:data][:score]
        i.title       = item[:data][:title]
        i.kids        = item[:data][:kids]
        i.parts       = item[:data][:parts]
        i.descendants = item[:data][:descendants]
        i.context     = item[:data][:type]
      end
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
