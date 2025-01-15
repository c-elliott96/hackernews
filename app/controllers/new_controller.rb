# frozen_string_literal: true

# Gets /newstories
class NewController < ApplicationController
  def index
    @page = HackerNews::Utils.normalized_page(params[:p])

    ids = HackerNewsRequestor.new(api: :hn, resource: :new_stories)
                             .call[:data]
                             .slice(HackerNews::Utils.page_range(@page))

    @stories = HackerNews::Utils.get_items_from_ids(ids)

    @stories.each_with_index do |story, i|
      set_story_rank(story, i)
    end
  end

  private

  def set_story_rank(story, index)
    story.rank = (@page - 1) * Constants::MAX_ITEMS_PER_PAGE + index + 1
  end
end
