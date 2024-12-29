# frozen_string_literal: true

module Constants
  BASE_HN_URI = "https://hacker-news.firebaseio.com/v0/"

  HN_RESOURCES = {
    item: "item",
    user: "user",
    maxitem: "maxitem",
    top_stories: "topstories",
    new_stories: "newstories",
    best_stories: "beststories",
    ask_stories: "askstories",
    show_stories: "showstories",
    job_stories: "jobstories"
  }.freeze

  BASE_ALGOLIA_URI = "http://hn.algolia.com/api/v1/"

  ALGOLIA_RESOURCES = {
    items: "items",
    users: "users",
    search: "search",
    search_by_date: "search_by_date",
    query: ""
  }.freeze

  NAV_ITEM_NAMES = %w[new past comments ask show jobs submit].freeze

  MAX_ITEMS_PER_PAGE = 30 # The max number of items we display per page
  MAX_PAGES_OF_ITEMS = 16 # The max number of pages of items for /, /news, etc.
end
