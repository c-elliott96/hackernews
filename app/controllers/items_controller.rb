# frozen_string_literal: true

# Controller for HackerNews items.
# #index corresponds to the list view of stories, jobs, etc.
# #show corresponds to the detail view of a story, job, etc. with commets.
class ItemsController < ApplicationController
  def index
    # Render the list Items according to the resource, which is selected in the navigation bar
    #
    # [Y] Hacker News new | past | comments | ask | show | jobs | submit
    #
    # | Clickable element | HackerNews URL endpoint | Apparent resource requested |
    # | [Y]               | /                       | (HN) :top_stories           |
    # | Hacker News       | /news                   | (HN) :top_stories           |
    # | new               | /newest                 | (HN) :new_stories           |
    # | past              | /front                  | (Algolia) :search_by_date   |
    # | comments          | /newcomments            | (Algolia) :search_by_date   |
    # | ask               | /ask                    | (HN) :ask_stories           |
    # | show              | /show                   | (HN) :show_stories          |
    # | jobs              | /jobs                   | (HN) :job_stories           |
    # | submit            | /submit                 | N/A (requires login)        |
    #
    # NOTE: The navigation bar changes based on page context. Determine what other
    # index resources I need to account for.

    @page = normalized_page

    ids = HackerNews::Request.new.get(api: :hn, resource: :news)[:data].slice(page_range)

    p resource
  end

  def show; end

  private

  def api(resource)
    # TODO
  end
end
