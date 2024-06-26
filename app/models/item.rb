# frozen_string_literal: true

# Item, defined by HN API.
class Item < ApplicationRecord
  # Allows us to set a rank for Items (e.g. when we are assembling a list of
  # items like from /topstories). It becomes the <li> index.
  attr_accessor :rank
end
