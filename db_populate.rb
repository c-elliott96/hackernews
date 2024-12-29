# frozen_string_literal: true

# SHOULD THIS BE IN `tasks/`? Make sure Rails doesn't try to run it on startup!
# utility script to test space required to store HN data in DB.
#
# Populate DB with NUM_ENTRIES items, from `/maxitem` to maxitem - NUM_ENTRIES.

item_id = HackerNews.get(resource: :maxitem)[:data]&.to_i

1000.times do
  item = HackerNews.get(resource: :item, id: item_id)

  Item.create do |i|
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

  item_id -= 1
end

p "hello"

# Trial run of 1000 row entries worked, it seems.
# Size of hackernews_development database: ~ 8,500,000B

# Average size of entry = 8_500_000 / 1000 = 8.5KB each
# TODO: Confirm my math and determine how many rows we could fit in to ~ 100GB
# of disk
