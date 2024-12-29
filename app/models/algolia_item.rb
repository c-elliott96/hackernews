# frozen_string_literal: true

# This class represents the JSON structure the Algolia HN API returns for the
# /items endpoint
class AlgoliaItem
  include ActiveModel::Model

  # All fields map to the fields of the same name in the Algolia API, except:
  # :rank - the index of the story/item in an ordered list
  # :link_domain_name - the link description, e.g. `google.com` for a story
  # :score_string - the score string e.g. "391 points by USERNAME"
  attr_accessor(
    :author,
    :children,
    :created_at,
    :created_at_i,
    :id,
    :options,
    :parent_id,
    :points,
    :story_id,
    :text,
    :title,
    :type,
    :url,
    :link_domain_name,
    :rank,
    :score_string,
    :comment_string,
    :num_comments
  )
end
