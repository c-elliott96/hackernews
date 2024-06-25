# frozen_string_literal: true

# Gets /topstories
class NewsController < ApplicationController
  before_action :prepare_page_range

  def index # rubocop:disable Metrics/MethodLength
    all_top_stories = HackerNews.get(resource: :top_stories)[:data]
    # array of ids for the top stories of a given range
    top_stories_page_p = all_top_stories.slice(@page_range)
    @stories = []
    threads = []
    top_stories_page_p.each_with_index do |id, index|
      threads << Thread.new do
        story_data = HackerNews.get(resource: :item, id:)[:data]
        @stories[index] = [story_data[:title], story_data[:url]]
      end
    end
    threads.each(&:join)
  end

  private

  def prepare_page_range # rubocop:disable Metrics/AbcSize
    # Validates and converts ?p param; sets @page_range, which is the range of items to return
    # from HN /topstories

    page =
      # handles the cases where p is not present or it's > 500/30
      if params[:p].nil? || params[:p].empty? || params[:p].to_i > 16 || params[:p].to_i < 1
        1
      else
        params[:p].to_i
      end

    @page_range = (page - 1) * 30..(page * 30) - 1
  end
end
