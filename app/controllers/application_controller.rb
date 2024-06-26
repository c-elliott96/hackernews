# frozen_string_literal: true

# Base application controller. All other controllers typically extend
# ApplicationController.
class ApplicationController < ActionController::Base
  def get_items_from_ids(ids) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    # Gets a range of items from HN API, using threads. Returns a list of Items.
    # Currently does not save them to the DB.
    # TODO: DB optimization.
    #   We will need to
    #       1. Check what items in the list of ids we have in the DB. Get them.
    #       2. Create threads to get the ones we don't.
    #       3. Save new items to the DB.
    #       4. Recombine the lists to return all items.
    items = []
    threads = []
    ids.each_with_index do |id, i|
      threads << Thread.new do
        item = HackerNews.get(resource: :item, id:)
        items[i] = item
      end
    end
    threads.each(&:join)
    # Here, we create Item objects for all the items. This ensures consistent
    # object types to consume. Later, we can use this to save things to the DB
    # if we want.
    items.map! do |item|
      Item.new do |i|
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
    items
  end
end
