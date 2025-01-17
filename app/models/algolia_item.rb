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
    # AlgoliaItems themselves. Need to handle the case where children data
    # already exists, and where children data are just IDs.
    if children_present? && children_are_ids?
      # init_children_items_from_ids
    elsif children_present? && !children_are_ids?
      init_children_items
    else
      self
    end
  end

  def children_present?
    !children.nil? && !children.empty?
  end

  def children_are_ids?
    children.all? { |child| child.is_a? Numeric }
  end

  # Assumes children items are Item-like objects
  def init_children_items
    children.map! { |child| self.class.new(child) }
  end

  # For when children array is an array of IDs
  def init_children_items_from_ids
    children.map! do |id|
      res = HackerNewsRequestor.new(api: :algolia, resource: :items, id:).call
      return nil if res[:code] != 200

      self.class.new(res[:data])
    end
    children.keep_if { |child| !child.nil? }
  end
end
