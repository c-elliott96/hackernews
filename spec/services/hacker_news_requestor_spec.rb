require "rails_helper"

RSpec.describe HackerNewsRequestor do
  describe ".new" do
    context "with missing args" do
      it "raises ArgumentError" do
        expect { subject.new }.to raise_error(ArgumentError, "missing keywords: :api, :resource")
      end
    end

    context "with required args" do
      let(:args) { { api: :some_api, resource: :some_resource, opts: :some_opts } }
      let(:requestor) { HackerNewsRequestor.new(**args) }
      it "creates instance" do
        expect { requestor }.not_to raise_error
      end
    end
  end
end
