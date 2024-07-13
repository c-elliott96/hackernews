# frozen_string_literal: true

# Item, defined by HN API.
class Item < ApplicationRecord
  # :rank - the index of the story/item in an ordered list
  # :link_domain_name - the link description, e.g. `google.com` for a story
  # :score_string - the score string e.g. "391 points by USERNAME"
  attr_accessor :rank, :link_domain_name, :score_string
end
