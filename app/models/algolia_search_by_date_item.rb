# This class adds fields that are included in Algolia's /search_by_date
# resource.
class AlgoliaSearchByDateItem < AlgoliaItem
  attr_accessor :_highlightResult, :_tags, :comment_text, :objectID,
                :story_title, :story_text, :story_url, :updated_at,
                :num_comments

  def initialize(item)
    super(item, search_by_date: true)
  end
end
