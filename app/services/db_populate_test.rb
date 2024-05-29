# frozen_string_literal: true

# utility script to test space required to store HN data in DB.
#
# Populate DB with NUM_ENTRIES items, from `/maxitem` to maxitem - NUM_ENTRIES.

NUM_ENTRIES = 1000

item_id = HackerNews.get(resource: :maxitem)[:data]&.to_i

NUM_ENTRIES.times do
  item_res = HackerNews.get(resource: :item, id: item_id)
  item_res[:data] unless item_res[:code]&.to_i != 200

  item_id -= 1
end
