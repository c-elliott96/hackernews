# frozen_string_literal: true

# Gets /askstories TODO: This controller can almost certainly be combined with
# NewsController. The only difference is the resource requested from HN.
class AskController < ApplicationController
  def index
    @page = HackerNews::Utils.normalized_page(params[:p])

    ids = HackerNewsRequestor.new(api: :hn, resource: :ask_stories)
                             .call[:data]
                             .slice(HackerNews::Utils.page_range(@page))

    @stories = HackerNews::Utils.get_items_from_ids(ids)

    @stories.each_with_index do |story, i|
      set_story_rank(story, i)
    end
  end

  private

  def set_story_rank(story, idx)
    story.rank = (@page - 1) * Constants::MAX_ITEMS_PER_PAGE + idx + 1
  end
end
