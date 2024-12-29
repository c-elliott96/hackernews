# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor(
    :hn_id,
    :created,
    :karma,
    :about,
    :submitted
  )
end
