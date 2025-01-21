require "rails_helper"

# TODO: Can I DRY this up too?

RSpec.describe ApplicationHelper do
  describe "::Comments" do
    describe ".comment_translation" do
      context "when item.children is nil" do
        it "returns 'item.discuss'" do
          item = AlgoliaItem.new({})
          comment = ApplicationHelper::Comments.new(item)
          expect(comment.comment_translation).to eq("item.discuss")
        end
      end
      context "when comment_count is 0" do
        it "returns 'item.discuss'" do
          item = AlgoliaItem.new({ children: [] })
          comment = ApplicationHelper::Comments.new(item)
          expect(comment.comment_translation).to eq("item.discuss")
        end
      end
      context "when comment_count is 1" do
        it "returns 'item.comment'" do
          item = AlgoliaItem.new(
            {
              # :type = "comment" is required, as count_comments checks for
              # children types.
              children: [{ author: "child", type: "comment" }]
            }
          )
          comment = ApplicationHelper::Comments.new(item)
          expect(comment.comment_translation).to eq("item.comment")
        end
      end
      context "when comment_count is > 1" do
        it "returns 'item.comments'" do
          item = AlgoliaItem.new(
            {
              children: [
                { author: "child1", type: "comment" },
                { author: "child2", type: "comment" },
                {
                  author: "child3WithChildren",
                  type: "comment",
                  children: [{ author: "subChild1", type: "comment" }]
                },
                # set :type to 'story' to check logic in #count_comments
                { author: "missplacedChild", type: "story" }
              ]
            }
          )
          comment = ApplicationHelper::Comments.new(item)
          expect(comment.comment_translation).to eq("item.comments")
        end
      end
    end
  end
end
