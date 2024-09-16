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
end
