# frozen_string_literal: true

# View helpers for all views.
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
    def count_comments(item)
      return @comment_count unless item.children.length.positive?

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
        t "item.discuss"
      when 1
        "#{@comment_count} #{t 'item.comment'}"
      else
        "#{@comment_count} #{t 'item.comments'}"
      end
    end
  end

  # Creates an i18n string for displaying the score of an item
  class Points
    def self.points(points, author)
      return "" unless !points.nil? || !points.empty? || points.zero?

      point_or_points = points == 1 ? t("item.point") : t("item.points")
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
