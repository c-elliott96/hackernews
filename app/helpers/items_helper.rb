# frozen_string_literal: true

# Helper methods for the Items view
module ItemsHelper
  def url_domain(item_url)
    return "" if item_url.nil? || item_url.empty?

    # It appears that HN gives special treatment to github domains, e.g.
    # displaying github.com/vladm7 instead of just github.com, which implies an
    # internal whitelist and formatting to such things, but I won't worry about
    # that for now.
    uri = URI(item_url)
    "(#{PublicSuffix.parse(uri.hostname).domain})"
  end

  def score_string(score, by)
    return "" unless !score.nil? || !score.empty? || score.zero?

    point_or_points = score == 1 ? "point" : "points"
    "#{score} #{point_or_points} by #{by}"
  end

  def current_page
    if params[:p].to_i <= Constants::PAGES_IN_NEWS
      params[:p].to_i
    else
      0
    end
  end

  def next_page
    if current_page.zero?
      2
    elsif current_page == Constants::PAGES_IN_NEWS
      1
    else
      current_page + 1
    end
  end

  def next_item(item, item_index)
    item_index < item.kids_items.length - 1 ? item.kids_items[item_index + 1] : nil
  end

  def prev_item(item, item_index)
    item_index.positive? ? item.kids_items[item_index - 1] : nil
  end

  def item_rank_width_class
    # If current page < 4, we're displaying item ranks in the range 1..90, so
    # we can create a width for the rank that corresponds to two digits.
    # Otherwise, we're displaying a rank within the range 91..500. In all cases,
    # we want to display a rank width that looks good for three digits.
    if current_page < 4
      "w-6"
    else
      "w-8"
    end
  end
end
