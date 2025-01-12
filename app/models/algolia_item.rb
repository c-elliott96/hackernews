# New code to replace AlgoliaItem
class AlgoliaItem
  include ActiveModel::AttributeAssignment

  # values from API JSON
  attr_accessor :author, :children, :created_at, :created_at_i, :id, :options, :parent_id,
                :points, :story_id, :text, :title, :type, :url

  # values computed for view
  attr_accessor :rank, :score_string, :comment_string, :link_domain_name

  def initialize(attributes)
    # Assign the attributes retrieved from the API call. The attributes returned
    # from the Algolia /items resource match the attributes listed above in the
    # first attr_accessor.
    assign_attributes(attributes)

    # If attributes[:children] present, we want to make all of those
    # AlgoliaItems themselves.
    init_children_items unless children.nil? || children.empty? || !children.is_a?(Array)
  end

  def init_children_items
    children.map! { |child| self.class.new(child) }
  end
end
