# frozen_string_literal: true

# Gets /topstories to display as an index (#index) or show a specific story
# (#show). #index utilizes the HN API endpoint, while #show uses Algolia /items.
class NewsController < ApplicationController
  # Display a list of top_stories, based on querey param `p`. 30 stories are
  # shown per page. Creates @page to display in the view, along with @items, an
  # array of HackerNewsItem.
  def index
    @page = normalized_page

    ids = HackerNewsRequestor.new(api: :hn, resource: :top_stories)
                             .call[:data].slice(page_range)

    @items = get_items_from_ids(ids)

    @items.each_with_index do |item, i|
      set_item_rank_link_score(item, i)
    end
  end

  # Show the contents of a single item, usually a story, which consists of the
  # story details (title, link, text, etc.), along with any comments associated
  # with it. These comments are themselves `items`, so this functionality is
  # recursive in the model. Creates @num_comments to display in the view, along
  # with @item, which itself keeps track of potentially many child items
  # (comments).
  def show
    id = params[:id]
    item_res_data = HackerNewsRequestor.new(api: :algolia, resource: :items, id:).call[:data]
    # not sure why I can't chain #create here, but it doesn't seem to work.
    @item = AlgoliaItem.new(item_res_data)
  end

  private

  def set_item_rank_link_score(item, idx)
    item.rank = (@page - 1) * Constants::MAX_ITEMS_PER_PAGE + idx + 1
    # TODO: Make this go to the #from?site=... action like HN
    item.link_domain_name = url_domain(item.url)
    item.score_string = score_string(item.score, item.by)
  end
end
