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

  It looks like the "Top" posts (i.e. the https://news.ycombinator.com/news) are a list of the top posts of the last 24 hours. If you click "More" at the bottom of the page, you navigate to the /news resource, but with a query param `p`. I assume this list is regenerated server-side on some time interval. Recreating this could involve using something like https://github.com/sidekiq-scheduler/sidekiq-scheduler to run automated jobs on an interval. I could also test the interval theory if I wanted to.

  Btw, [here's](https://vigneshwarar.substack.com/p/hackernews-ranking-algorithm-how) a write-up on the ranking algorithm, which will be needed.

* [ ] Add models

* [ ] Remove DB and associated tooling unless needed
