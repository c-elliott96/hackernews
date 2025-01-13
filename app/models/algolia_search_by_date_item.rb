# This class adds fields that are included in Algolia's /search_by_date
# resource.
class AlgoliaSearchByDateItem < AlgoliaItem
  attr_accessor :_highlightResult, :_tags, :comment_text, :objectID,
                :story_title, :story_text, :story_url, :updated_at,
                :num_comments

  # def create
  #   assign_attributes(@attributes)
  #   # We don't need to compute @num_comments like we do in the parent class.
  #   run_callbacks(:create)
  # end

  # private

  # # Finalize the @item. To do so, we set up all the children items, and compute
  # # the link_domain_name, the score_string, and the comment_string.
  # def finalize
  #   @link_domain_name = url_domain(url)
  #   @score_string = create_score_string if @attributes[:points]
  #   @comment_string = create_comment_string
  # end
end
