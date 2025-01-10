# frozen_string_literal: true

# Gets comments from Algolia API for a given date.
# Uses /search_by_date Algolia resource.
class CommentsController < ApplicationController
  def index
    @page = normalized_page

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

  def setup_items(data) # rubocop:disable Metrics/MethodLength
    data[:hits].each_with_index do |item, _idx|
      # @items.append(
      #   AlgoliaItem.new(
      #     id: item[:id],
      #     created_at: item[:created_at],
      #     author: item[:author],
      #     title: item[:title],
      #     text: item[:text],
      #     points: item[:points],
      #     type: item[:type],
      #     score_string: item[:points] ? score_string(item[:points], item[:author]) : nil,
      #     comment_string: nil,
      #     children: item[:children]
      #   )
      # )
      algolia_item = AlgoliaSearchByDateItem.new(item)
      @items.append(algolia_item)
    end
  end
end
