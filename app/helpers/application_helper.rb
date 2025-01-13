# frozen_string_literal: true

# View helpers for all views.
#
# Makes available the following Classes and Methods:
#
# ApplicationHelper::Comments.new
#   Creates a new Comments object. Sets @comment_count to 0.
#
# ApplicationHelper::Comments.count_comments(item),
#   Walks through item tree, counting the total number of children that are
#   comments. Returns @comment_count, which has now been updated. Assumes item
#   is of type AlgoliaItem.
#   TODO: Support both HackerNewsItem and AlgoliaItem indifferently.
# ApplicationHelper::Comments.comment_string
#   i18n's the @comment_count.
#
# ApplicationHelper::Points.points(points, author),
#   i18n's the points, based on @param points and @param author.
#   TODO: Make the return value also i18n. Needs variable placement. Investigate.
#
# ApplicationHelper::LinkDomainCreator.new(url),
#   Sets @link_domain_name, based on the url.
#
# TODO: Yard docstrings.
module ApplicationHelper
  # Class for counting the comments in an item. Must support arbitrarily nested
  # Items.
  class Comments
    # Set the comment count
    def initialize
      @comment_count = 0
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
      return @comment_count unless item&.children&.length&.positive?

      # Ensure children Items are of type "comment"
      child_comments = 0
      item.children.each { |child| child.type == "comment" ? child_comments += 1 : nil }
      @comment_count += child_comments

      # For each child, recursively call this method
      item.children.each { |child| count_comments(child) }

      # Finally, return the total count
      @comment_count
    end

    # Creates an i18n string for displaying the number of comments in the
    # subheading of an Item.
    def comment_string
      case @comment_count
      when 0
        I18n.t "item.discuss"
      when 1
        "#{@comment_count} #{I18n.t 'item.comment'}"
      else
        "#{@comment_count} #{I18n.t 'item.comments'}"
      end
    end

    def self.comment_string(num_comments)
      case num_comments
      when 0
        I18n.t "item.discuss"
      when 1
        "#{num_comments} #{I18n.t 'item.comment'}"
      else
        "#{num_comments} #{I18n.t 'item.comments'}"
      end
    end
  end

  # Creates an i18n string for displaying the score of an item
  class Points
    def self.points(points, author)
      return "" unless !points.nil? || !points.empty? || points.zero?

      point_or_points = points == 1 ? I18n.t("item.point") : I18n.t("item.points")
      "#{points} #{point_or_points} by #{author}"
    end
  end

  # Class for creating a domain name for displaying in the view, based on the
  # "url" value of the Item.
  class LinkDomainCreator
    attr_accessor :link_domain_name

    def initialize(url)
      @link_domain_name = domain_name(url)
    end

    private

    def domain_name(url)
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
