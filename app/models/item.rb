# frozen_string_literal: true

# Item, defined by HN API.
class Item < ApplicationRecord
  # TODO: Explain these briefly
  attr_accessor :rank, :link_domain_name, :score_string
end
