# frozen_string_literal: true

# Gets /topstories
class NewsController < ApplicationController
  before_action :page_range

  # /topstories, /newstores, /beststories give us 500 stories. We display 30
  # stories per page.
  ITEMS_PER_PAGE = 30
  TOTAL_PAGES = 16

  def index
    ids = HackerNews.get(resource: :top_stories)[:data].slice(page_range)
    @stories = get_items_from_ids(ids)

    # Set the rank of each story, which is just its index in the original array,
    # but we throw that away so we can recompute the index here.
    @stories.each_with_index do |story, i|
      story.rank = (@page - 1) * ITEMS_PER_PAGE + i + 1
    end
  end

  private

  def invalid_param_p?(param_p)
    param_p.nil? || param_p.empty? || (param_p.to_i > TOTAL_PAGES || param_p.to_i < 1)
  end

  def page_range
    # Validates and converts ?p param; Returns a range, which is the range of
    # items to get from HN /topstories

    @page =
      if invalid_param_p? params[:p]
        1
      else
        params[:p].to_i
      end

    (@page - 1) * 30..(@page * 30) - 1
  end
end
