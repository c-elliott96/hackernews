# frozen_string_literal: true

# Gets /topstories
class NewsController < ApplicationController
  # /topstories, /newstores, /beststories give us 500 stories. We display 30
  # stories per page.
  ITEMS_PER_PAGE = 30
  TOTAL_PAGES = 16

  def index # rubocop:disable Metrics/AbcSize
    @page = normalized_page # instance variable to use in view

    # Get the ids, returned by the HN service.
    ids = HackerNews.get(resource: :top_stories)[:data].slice(page_range)
    # Retrieve the associated items.
    @stories = get_items_from_ids(ids)

    # Set the rank of each story, for front-end display.
    @stories.each_with_index do |story, i|
      story.rank = (@page - 1) * ITEMS_PER_PAGE + i + 1
      # TODO: Make this go to the #from?site=... action like HN
      story.link_domain_name = url_domain(story.url)
      story.score_string = score_string(story.score, story.by)
    end
  end

  private

  def normalized_page
    if invalid_param_p? params[:p]
      1
    else
      params[:p].to_i
    end
  end

  def invalid_param_p?(param_p)
    param_p.nil? || param_p.empty? || (param_p.to_i > TOTAL_PAGES || param_p.to_i < 1)
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
