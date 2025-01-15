require "rails_helper"

# TODO: Can I DRY this up too?

RSpec.describe ApplicationHelper do
  describe "Comments" do
    # describe "self.count_comments" do

    # end
    describe "self.comment_string" do
      it "returns 'discuss' when there are zero comments" do
        i18n = class_double(I18n)
        allow(i18n).to receive(:t).with("item.discuss")
                   .and_return("discuss")
        expect(ApplicationHelper::Comments.comment_string(0)).to eq("discuss")
      end

      it "returns '1 comment' when there is one comment" do
        i18n = class_double(I18n)
        allow(i18n).to receive(:t).with("item.comment")
                   .and_return("1 comment")
        expect(ApplicationHelper::Comments.comment_string(1)).to eq("1 comment")
      end

      it "returns '10 comments' when there are ten comments" do
        i18n = class_double(I18n)
        allow(i18n).to receive(:t).with("item.comments")
                   .and_return("10 comments")
        expect(ApplicationHelper::Comments.comment_string(10)).to eq("10 comments")
      end
    end
  end
end
