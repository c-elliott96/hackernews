# frozen_string_literal: true

# Controller for HackerNews items.
# #index corresponds to the list view of stories, jobs, etc.
# #show corresponds to the detail view of a story, job, etc. with commets.
class ItemsController < ApplicationController
  def index(api)
    # Render the list Items according to the resource, which is selected in the navigation bar
    #
    # ------------------------------------------------------------------------------------
    #  [Y] **Hacker News** new | past | comments | ask | show | jobs | submit | ... login
    # ------------------------------------------------------------------------------------
    #
    # |---------------------------------------------------------------------------|
    # | CLICKABLE ELEMENT | HACKERNEWS URL ENDPOINT | APPARENT RESOURCE REQUESTED |
    # |---------------------------------------------------------------------------|
    # | [Y]               | /                       | (HN) :top_stories           |
    # | Hacker News       | /news                   | (HN) :top_stories           |
    # | Standard index view. Up to 500 stories                                    |
    # |---------------------------------------------------------------------------|
    # | new               | /newest                 | (HN) :new_stories           |
    # | Highlight the nav item. Standard index view. Up to 500 stories.           |
    # |---------------------------------------------------------------------------|
    # | past              | /front                  | (Algolia) :search_by_date   |
    # | Date in the nav, highlighted; Date range details at the top above the     |
    # | index. Will need to paginate Algolia response. Unclear how items ranked.  |
    # |---------------------------------------------------------------------------|
    # | comments          | /newcomments            | (Algolia) :search_by_date   |
    # | Different from other views. Will need to paginate Algolia response.       |
    # |---------------------------------------------------------------------------|
    # | ask               | /ask                    | (HN) :ask_stories           |
    # | Identical to newest, except often have body text and link takes you to    |
    # | the item itself, and there is no url in parenthesis. Up to 200.           |
    # |---------------------------------------------------------------------------|
    # | show              | /show                   | (HN) :show_stories          |
    # | Rules disclaimer at the top of index. Up to 200. Identical to /ask        |
    # | otherwise.                                                                |
    # |---------------------------------------------------------------------------|
    # | jobs              | /jobs                   | (HN) :job_stories           |
    # | Another banner at the top (like /show). Only time string in the 2nd row.  |
    # | Up to 200.                                                                |
    # |---------------------------------------------------------------------------|
    # | submit            | /submit                 | N/A (requires login)        |
    # | N/a.                                                                      |
    # |---------------------------------------------------------------------------|

    p api
  end

  def show; end
end
