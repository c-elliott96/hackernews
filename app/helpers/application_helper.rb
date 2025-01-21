# frozen_string_literal: true

# View helpers for all views.
#
# Makes available the following Classes and Methods:
#
# ApplicationHelper::Comments.new
#   Creates a new Comments object. Sets @comment_count to 0.
#
# ApplicationHelper::Comments.count_comments(item),
#
#   NOTE: Currently unused.
#
#   Walks through item tree, counting the total number of children that are
#   comments. Returns @comment_count, which has now been updated. Assumes item
#   is of type AlgoliaItem.
#
#   TODO: Support both HackerNewsItem and AlgoliaItem indifferently.
#
# ApplicationHelper::Comments.comment_translation
#
#   Returns the translation string for the number of comments.
#
#   NOTE: Broken and unused. I've moved to favoring variable translations
#   instead. The translation strings this method returns will not work.
#
# ApplicationHelper::Links.domain_name(url),
#
#   Returns domain name based on the url.
#
# TODO: Yard docstrings.
module ApplicationHelper
  # Class for counting the comments in an item. Must support arbitrarily nested
  # Items.
  #
  # NOTE: Currently unused. Switching to useful variable translations instead.
  # Only caveat is that regular AlgoliaItems (which come from the /items
  # resource) do not explicitly return the :num_comments field. We have to
  # iterate over the children and count them manually. Leaving this for now in
  # case I need to make use of it.
  class Comments
    # Set the comment count
    def initialize(item)
      @comment_count =
        if num_comments?(item)
          item.num_comments
          return
        else
          0
        end
      count_comments(item)
    end

    # Creates an i18n string for displaying the number of comments in the
    # subheading of an Item.
    def comment_translation
      case @comment_count
      when 0
        "item.discuss"
      when 1
        "item.comment"
      else
        "item.comments"
      end
    end

    private

    # Determines if item.num_comments exists
    def num_comments?(item)
      return true if item.respond_to?(:num_comments) && !item.num_comments.nil?

      false
    end

    # Recursively iterates over item's children, if any, and computes the
    # total number of comments.
    #
    # @param item [AlgoliaItem] the Item whose children (also AlgoliaItems) we
    # are iterating over.
    #
    # @note This recursive tree navigation is not necessary for
    # HackerNewsItem's, that include @descendants from the API.
    def count_comments(item)
      # Return @comment_count if item.children doesn't exist or is empty.
      return @comment_count if item.children.nil?
      # Return @comment_count if item.children.length is not positive.
      return @comment_count unless item.children.length.positive?

      # Ensure children Items are of type "comment". This probably should never
      # be the case.
      child_comments = 0
      # item.children.each { |child| child.type == "comment" ? child_comments += 1 : nil }
      item.children.each do |child|
        next if child.nil?

        child.type == "comment" ? child_comments += 1 : nil
      end
      @comment_count += child_comments

      # For each child, recursively call this method
      item.children.each { |child| count_comments(child) }

      # Finally, return the total count
      @comment_count
    end
  end

  # Class for creating a domain name for displaying in the view, based on the
  # "url" value of the Item.
  class Links
    def self.domain_name(url)
      return "" if url.nil? || url.empty?

      # It appears that HN gives special treatment to github domains, e.g.
      # displaying github.com/vladm7 instead of just github.com, which implies an
      # internal whitelist and formatting to such things, but I won't worry about
      # that for now.
      uri = URI(url)
      "(#{PublicSuffix.parse(uri.hostname).domain})"
    end
  end
end
