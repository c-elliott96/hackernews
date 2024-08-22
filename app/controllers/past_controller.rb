# frozen_string_literal: true

# Gets a list of posts from a given date, sorted by some ranking.
#
# `/front`, on HN.
class PastController < ApplicationController
  # Allowed params: day (defaults to yesterday), p (pagination)
  def index
    # without a full HN db mirror, it will be impractical to try to implement
    # this behavior.
  end
end
