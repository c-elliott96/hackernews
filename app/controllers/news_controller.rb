# frozen_string_literal: true

# Gets /topstories
class NewsController < ApplicationController
  def index
    @page = normalized_page

    ids = HackerNews::Request.new.get(api: :hn, resource: :top_stories)[:data].slice(page_range)

    @items = get_items_from_ids(ids)

    @items.each_with_index do |item, i|
      set_item_rank_link_score(item, i)
    end
  end

  def show
    id = params[:id]
    item = HackerNews::Request.new.get(api: :algolia, resource: :items, id:)[:data]
    @num_comments = 0
    tally_comments(item[:children])
    @item = setup_item(item)
    # Need to parse out important fields from Algolia items data
  end

  private

  def setup_item(item) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    AlgoliaItem.new(
      author: item[:author],
      children: setup_children(item[:children]),
      created_at: item[:created_at],
      created_at_i: item[:created_at_i],
      id: item[:id],
      options: item[:options],
      parent_id: item[:parent_id],
      points: item[:points],
      text: item[:text],
      title: item[:title],
      type: item[:type],
      url: item[:url],
      link_domain_name: url_domain(item[:url]),
      score_string: item[:points] ? score_string(item[:points], item[:author]) : nil,
      comment_string:,
      rank: nil # TODO
    )
  end

  def setup_children(children)
    children&.map do |child|
      setup_item(child)
    end
  end

  def tally_comments(children)
    # For each child, add the length of its children. Then call this method on
    # its children, etc.
    @num_comments += children.length
    children.each do |child|
      next if child[:children].empty?

      @num_comments += child[:children].length
      child[:children].each do |sub_child|
        tally_comments(sub_child[:children])
      end
    end
  end

  def comment_string
    case @num_comments
    when 0
      "discuss"
    when 1
      "#{@num_comments} comment"
    else
      "#{@num_comments} comments"
    end
  end

  def set_item_rank_link_score(item, idx)
    item.rank = (@page - 1) * Constants::MAX_ITEMS_PER_PAGE + idx + 1
    # TODO: Make this go to the #from?site=... action like HN
    item.link_domain_name = url_domain(item.url)
    item.score_string = score_string(item.score, item.by)
  end
end
