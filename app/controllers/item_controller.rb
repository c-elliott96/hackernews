# frozen_string_literal: true

# Controller responsible for viewing an item and its children -- usually a story
# and its comments' trees.
class ItemController < ApplicationController
  def index
    # Expect param `id` to find the item

    # Top level Item -- e.g. the HN story.
    # TODO: Gracefully handle invalid_param_id?
    @item = get_item_from_id(params[:id])

    # We need to get all children and children's children of @item, etc.
    # @item.kids is an array of the top-level children items.

    return if @item.kids.nil?

    # Use the array of ids (@item.kids) to set the array of Item objects
    @item.kids_items = get_items_from_ids(@item.kids)

    # Set the ActiveRecord relationship and step into the next level of items.
    @item.kids_items.each do |kid|
      kid.parent_item = @item
      get_descendants(kid)
    end

    # We now have a hierarchy of items for the view to render:
    #
    # @TopLevelItem.kids_items -> kid1, kid2, kid3, ...
    # kid1.kids_items -> kid1a, kid1b, ...
    # kid1.parent_item -> @TopLevelItem
    # ...
  end

  private

  # validates the query param. I'm not sure how essential this validation is.
  def invalid_param_id?
    id = Integer(params[:id], exception: false) # nil if error raised
    !id.nil? || id.negative?
  end

  # recursively gets the children items of an item. Exits recursion when the
  # current item has no kids. Sets the item.kids_items, and the kid items
  # parent, to reflect the relationships.
  #
  # For large comment trees, this method is /slow/. I will need to investigate
  # how to improve it, if possible.
  def get_descendants(item)
    return if item.kids.nil?

    kids = get_items_from_ids(item.kids)
    kids.each do |kid|
      item.kids_items.append(kid)
    end
    item.kids_items.each do |kid|
      kid.parent_item = item
      get_descendants(kid)
    end
  end
end
