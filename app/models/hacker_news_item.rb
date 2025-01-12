# frozen_string_literal: true

# The commented block below represents how I handled hierarchical relationships
# between items when using the DB setup (ActiveRecord). I am moving away from
# this, since using ActiveRecord, even to just instantiate the models, consumes
# DB threads, which limits how much multithreading I can do when we have to set
# up many Item objects at once. Leaving it here in case it's useful in the
# future. [2024-12-30 Mon]
# -----------------------------------------------------------------------------
# Item, defined by HN API. class Item < ApplicationRecord #
# https://discuss.rubyonrails.org/t/help-with-associations-self-joins-example/81864
# # Allows an Item to reference other items, for the sake of handling comment #
# hierarchies has_many :kids_items, class_name: "Item", foreign_key:
# "parent_hn_id"

#   belongs_to :parent_item, class_name: "Item", optional: true

#   # For the issue of how to display comments russian-doll style, see
#   # https://stackoverflow.com/questions/48799432/how-to-properly-render-nested-comments-in-rails
#
#   # :rank - the index of the story/item in an ordered list
#   # :link_domain_name - the link description, e.g. `google.com` for a story
#   # :score_string - the score string e.g. "391 points by USERNAME"
#   attr_accessor :rank, :link_domain_name, :score_string
# end
# -----------------------------------------------------------------------------

# This class represents the JSON structure the HN API returns for various
# resources
class HackerNewsItem
  include ActiveModel::AttributeAssignment

  # values from API JSON
  attr_accessor :id, :deleted, :by, :time, :text, :dead, :parent, :poll, :url,
                :score, :title, :kids, :parts, :descendants, :type

  # values computed from data. @rank needs to be computed from the
  # Controller/Model, because it depends on the controller's @page value.
  attr_accessor :rank
end
