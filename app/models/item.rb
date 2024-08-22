# frozen_string_literal: true

# Item, defined by HN API.
class Item < ApplicationRecord
  # https://discuss.rubyonrails.org/t/help-with-associations-self-joins-example/81864
  # Allows an Item to reference other items, for the sake of handling comment
  # hierarchies
  has_many :kids_items, class_name: "Item",
                        foreign_key: "parent_hn_id"

  belongs_to :parent_item, class_name: "Item", optional: true

  # For the issue of how to display comments russian-doll style, see
  # https://stackoverflow.com/questions/48799432/how-to-properly-render-nested-comments-in-rails

  # :rank - the index of the story/item in an ordered list
  # :link_domain_name - the link description, e.g. `google.com` for a story
  # :score_string - the score string e.g. "391 points by USERNAME"
  attr_accessor :rank, :link_domain_name, :score_string
end
