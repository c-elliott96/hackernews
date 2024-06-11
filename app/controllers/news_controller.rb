# frozen_string_literal: true

# Gets /topstories
class NewsController < ApplicationController
  before_action :prepare_page_range

  def index
    # @page_range is the range of the /topstories we want to display
    top_stories_data = HackerNews.get(resource: :top_stories)[:data] # this could be an empty hash
    p "selecting #{@page_range} from top_stories ..."
    @top_stories_page_p = top_stories_data.slice(@page_range)
  end

  private

  def prepare_page_range
    # what's a more concise way to do this?
    p =
      # handles the cases where p is not present or it's > 500/30
      if params[:p].nil?
        0
      elsif params[:p].empty? || p.to_i > 16
        0
      else
        params[:p].to_i
      end

    @page_range = p * 30..((p + 1) * 30) - 1
  end
end
