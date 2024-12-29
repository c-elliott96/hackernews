class CommentsController < ApplicationController
  def index
    @page =
      if params[:p].blank?
        0
      else
        params[:p]
      end

    opts = {
      tags: :comment,
      hitsPerPage: 30,
      page: @page
    }

    @items = []

    setup_items(HackerNews::Request.new.get(api: :algolia, resource: :search_by_date, **opts)[:data])
  end

  private

  def setup_items(data)
    data[:hits].each_with_index do |item, idx|
      @items.append(
        AlgoliaItem.new(
          id: item[:id],
          created_at: item[:created_at],
          author: item[:author],
          title: item[:title],
          text: item[:text],
          points: item[:points],
          type: item[:type],
          score_string: item[:points] ? score_string(item[:points], item[:author]) : nil,
          comment_string: nil,
          children: item[:children]
        )
      )
    end
  end
end
