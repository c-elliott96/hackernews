require "rails_helper"

# TODO: DRY it up with shared examples. https://rspec.info/features/3-12/rspec-core/example-groups/shared-examples/
# TODO: Handle invalid args in the subject's code

RSpec.describe HackerNewsRequestor do
  describe ".call" do
    context "with valid args" do
      context "for HackerNews" do
        it "makes GET request to HackerNews without options" do
          uri = "#{Constants::BASE_HN_URI}topstories.json"
          res_json = { data_field: "val" }.to_json
          stub_request(:any, uri)
            .to_return(body: res_json, status: 200)
          requestor = HackerNewsRequestor.new(api: :hn, resource: :top_stories)
          requestor.call
          expect(WebMock).to have_requested(:get, uri)
        end

        it "makes GET request to HackerNews with options" do
          uri = "#{Constants::BASE_HN_URI}item/1.json"
          res_json = { data_field: "val" }.to_json
          stub_request(:any, uri)
            .to_return(body: res_json, status: 200)
          requestor = HackerNewsRequestor.new(api: :hn, resource: :item, id: 1)
          requestor.call
          expect(WebMock).to have_requested(:get, uri)
        end
      end

      context "for Algolia" do
        it "makes GET request to Algolia for items" do
          uri = "#{Constants::BASE_ALGOLIA_URI}items/1"
          res_json = { data_field: "val" }.to_json
          stub_request(:any, uri)
            .to_return(body: res_json, status: 200)
          requestor = HackerNewsRequestor.new(api: :algolia, resource: :items, id: 1)
          requestor.call
          expect(WebMock).to have_requested(:get, uri)
        end

        it "makes GET request to Algolia for users" do
          uri = "#{Constants::BASE_ALGOLIA_URI}users/pg"
          res_json = { data_field: "val" }.to_json
          stub_request(:any, uri)
            .to_return(body: res_json, status: 200)
          requestor = HackerNewsRequestor.new(api: :algolia, resource: :users, username: "pg")
          requestor.call
          expect(WebMock).to have_requested(:get, uri)
        end

        it "makes GET request to Algolia for search or search_by_date" do
          uri = "#{Constants::BASE_ALGOLIA_URI}search?tags=story"
          opts = { tags: :story }
          res_json = { data_field: "val" }.to_json
          stub_request(:any, uri)
            .to_return(body: res_json, status: 200)
          requestor = HackerNewsRequestor.new(api: :algolia, resource: :search, **opts)
          requestor.call
          expect(WebMock).to have_requested(:get, uri)
        end
      end
    end
  end
end
