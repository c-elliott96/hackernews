# frozen_string_literal: true

# Gets /topstories to display as an index (#index) or show a specific story
# (#show). #index utilizes the HN API endpoint, while #show uses Algolia /items.
class NewsController < ApplicationController
  # Display a list of top_stories, based on querey param `p`. 30 stories are
  # shown per page. Creates @page to display in the view, along with @items, an
  # array of HackerNewsItem.
  def index
    @page = HackerNews::Utils.normalized_page(params[:p])

    ids = HackerNewsRequestor.new(api: :hn, resource: :top_stories)
                             .call[:data]
                             .slice(HackerNews::Utils.page_range(@page))

    @items = HackerNews::Utils.get_items_from_ids(ids)

    @items.each_with_index do |item, i|
      set_item_rank(item, i)
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

  def set_item_rank(item, index)
    item.rank = (@page - 1) * Constants::MAX_ITEMS_PER_PAGE + index + 1
  end
end
