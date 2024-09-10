# frozen_string_literal: true

# Most objects internal to HN are Items.
class ItemsController < ApplicationController
  def index
    @items = items_from_ids(items_ids)
    # We set ranks here in the controller because it depends on the page of
    # items being rendered. We compute other additional Item display values
    # in the view/helper.
    setup_items_ranks
  end

  def show
    render :index if invalid_param_id?

    item_id = params[:id].to_i
    @item = find_or_create_item(item_id)
    return if @item.kids.nil?

    @item.kids_items = items_from_ids(@item.kids)
    @item.kids_items.each do |kid|
      kid.parent_item = @item
      get_descendants(kid)
    end
  end

  private

  def setup_items_ranks
    @items.each_with_index do |item, i|
      item.rank = (page - 1) * Constants::ITEMS_PER_PAGE + i + 1
    end
  end

  def items_from_ids(items_ids)
    items = []
    items_ids.each do |id|
      # TODO: set useful Item properties like rank, link_domain_name, score_string
      items.append(find_or_create_item(id))
    end
    items
  end

  def items_ids
    HackerNews.get(resource: :top_stories)[:data]
              .slice(page_range(page))
  end

  def find_or_create_item(id) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    Item.find_or_create_by(hn_id: id) do |i|
      item = HackerNews.get(resource: :item, id:)
      i.hn_id       = item[:data][:id]
      i.deleted     = item[:data][:deleted]
      i.by          = item[:data][:by]
      i.time        = item[:data][:time]
      i.text        = item[:data][:text]
      i.dead        = item[:data][:dead]
      i.parent      = item[:data][:parent]
      i.poll        = item[:data][:poll]
      i.url         = item[:data][:url]
      i.score       = item[:data][:score]
      i.title       = item[:data][:title]
      i.kids        = item[:data][:kids]
      i.parts       = item[:data][:parts]
      i.descendants = item[:data][:descendants]
      i.context     = item[:data][:type]
    end
  end

  def get_descendants(item)
    return if item.kids.nil?

    kids = items_from_ids(item.kids)
    kids.each do |kid|
      item.kids_items.append(kid)
    end
    item.kids_items.each do |kid|
      kid.parent_item = item
      get_descendants(kid)
    end
  end

  # Currently not in use, but should probably be used somehow. Or something
  # similar.
  def items_params
    params.permit(:p, :id)
  end

  def page
    return params[:p].to_i unless invalid_param_p?

    1
  end

  def invalid_param_p?
    p = params[:p]
    p.nil? || p.empty? ||
      (p.to_i > Constants::PAGES_IN_NEWS || p.to_i < 1)
  end

  def invalid_param_id?
    id = params[:id]
    id.nil? || id.empty? ||
      (id.to_i > HackerNews.get(resource: :maxitem)[:data] || id.to_i < 1)
  end

  def page_range(page)
    (page - 1) * 30..(page * 30) - 1
  end
end
