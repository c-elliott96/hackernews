# frozen_string_literal: true

# Gets comments from Algolia API for a given date.
# Uses /search_by_date Algolia resource.
class CommentsController < ApplicationController
  def index
    @page = HackerNews::Utils.normalized_page(params[:p])

    opts = {
      tags: :comment,
      hitsPerPage: 30,
      page: @page
    }

    @items = []

    setup_items(HackerNewsRequestor.new(api: :algolia, resource: :search_by_date, **opts)
                                   .call[:data])
  end

  private

  def setup_items(data)
    data[:hits].each_with_index do |item, _idx|
      algolia_item = AlgoliaSearchByDateItem.new(item)
      @items.append(algolia_item)
    end
  end
end
