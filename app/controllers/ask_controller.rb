# frozen_string_literal: true

# Gets /askstories
class AskController < ApplicationController
  def index
    @page = HackerNews::Utils.normalized_page(params[:p])

    ids = HackerNewsRequestor.new(api: :hn, resource: :ask_stories)
                             .call[:data].slice(page_range)

    @stories = HackerNews::Utils.get_items_from_ids(ids)

    @stories.each_with_index do |story, i|
      set_story_rank_link_score(story, i)
    end
  end

  private

  def set_story_rank_link_score(story, idx)
    story.rank = (@page - 1) * Constants::MAX_ITEMS_PER_PAGE + idx + 1
    # TODO: Make this go to the #from?site=... action like HN
    story.link_domain_name = HackerNews::Utils.url_domain(story.url)
    story.score_string = score_string(story.score, story.by)
  end
end
