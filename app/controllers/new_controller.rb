# frozen_string_literal: true

# Gets /newstories
class NewController < ApplicationController
  def index
    @page = normalized_page

    # Get the ids, returned by the HN service.
    ids = HackerNews.get(resource: :new_stories)[:data].slice(page_range)
    # Retrieve the associated items.
    @stories = get_items_from_ids(ids)

    # Set the rank of each story, for front-end display.
    @stories.each_with_index do |story, i|
      set_story_rank_link_score(story, i)
    end
  end

  private

  def set_story_rank_link_score(story, idx)
    # The rank is just the index of the story in the response of :top_stories
    story.rank = (@page - 1) * ITEMS_PER_PAGE + idx + 1
    # TODO: Make this go to the #from?site=... action like HN
    story.link_domain_name = url_domain(story.url)
    story.score_string = score_string(story.score, story.by)
  end
end
