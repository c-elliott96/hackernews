# hackernews

[Hackernews](https://news.ycombinator.com/) by Y Combinator, my way.

Leverages the [HackerNews API](https://github.com/HackerNews/API), and is bootstrapped via the [docker-rails-example](https://github.com/nickjj/docker-rails-example/tree/main) project by [Nick Janetakis](https://nickjanetakis.com/). Please check out their awesome work.

For details on the project's base Rails and Docker configurations, see the [`docker-rails-example/README`](https://github.com/nickjj/docker-rails-example/blob/c2e3a4bec4bf355b1c6882f34dd74eb438035a50/README.md).

## TODOs

Project TODOs go here. They could link to GitHub issues, if I so desire.

* [X] Bootstrap project
  Start with the docker-rails-example
* [X] Retrieve HackerNews data via the API
  Create `app/services/hacker_news.rb` to handle API requests
* [X] Add services/HackerNews tests
  Add `test/services/hacker_news_test.rb` to test service. In the future I'd like to swap RSpec for Minitest.
* [X] Add ruby lint command to `run`
* [ ] Plan main page
  Should mimic news.ycombinator.com landing page. This will inform controller design and model relationships.

  It looks like the "Top" posts (i.e. the https://news.ycombinator.com/news) are a list of the top posts of the last 24 hours. If you click "More" at the bottom of the page, you navigate to the /news resource, but with a query param `p`. I am not sure if this list is generated on every request or if it is generated on an interval. If I implemented the code to do it on a time interval, I could use something like [sidekiq-scheduler](https://github.com/sidekiq-scheduler). However, I have a lot of questions regarding this solution, and it might be easier to start with just the code to generate the list, and come back to the issue of efficiency later.

  Btw, [here's](https://vigneshwarar.substack.com/p/hackernews-ranking-algorithm-how) a write-up on the ranking algorithm, which will be needed.
  * [ ] `/news` (main page)
    list of top posts in the last 24 hours
    Display the pagination requested (defaults to page 1: 1-30).
    * A **post** is just an _item_ in HN API.
  After looking at all of this, I've realized that perhaps the most sensible way to do this would be to store the data we want in a local DB, then query that for e.g. the top posts list. This way, I can re-query the DB on every request, and just have the database re-populated with new HN data on some customizable interval. So, that being said, I need to
  * verify postgres works and I know how to use it,
  * get started with the ORM setup
* [ ] Verify Postgres setup and understand how to easily connect to the DB in dev
* [ ] Document the data structure to use for DB and ORMs
