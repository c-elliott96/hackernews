# hackernews

[Hackernews](https://news.ycombinator.com/) by Y Combinator, my way.

Leverages the [HackerNews API](https://github.com/HackerNews/API), and is bootstrapped via the [docker-rails-example](https://github.com/nickjj/docker-rails-example/tree/main) project by [Nick Janetakis](https://nickjanetakis.com/). Please check out their awesome work.

For details on the project's base Rails and Docker configurations, see the [`docker-rails-example/README`](https://github.com/nickjj/docker-rails-example/blob/c2e3a4bec4bf355b1c6882f34dd74eb438035a50/README.md).

## TODOs

Project TODOs go here. They could link to GitHub issues, if I so desire.

* [ ] Handle future API changes properly

  > For versioning purposes, only removal of a non-optional field or alteration of an existing field will be considered incompatible changes. Clients should gracefully handle additional fields they don't expect, and simply ignore them.

* [X] Bootstrap project

  Start with the docker-rails-example

* [X] Retrieve HackerNews data via the API

  Create `app/services/hacker_news.rb` to handle API requests

* [X] Add services/HackerNews tests

  Add `test/services/hacker_news_test.rb` to test service. In the future I'd like to swap RSpec for Minitest.

* [X] Add ruby lint command to `run`

* [ ] Determine how much data, approximately, the HN site stores

  * [X] Check on how to access Postgresql database

    Run `./run psql` and then e.g. `\c hackernews_development` to access the dev DB. `\d` to see the tables. `select * from items` for all rows from e.g. `items`.

  * [X] Determine how to create tables in Rails

    `./run rails g model ExampleModel` for creating a model and `./run rails g migration` to create a migration

  * [X] Create `Items` table that has the following fields:

    ```bash
      rails g model

        ...
        integer
        primary_key
        decimal
        float
        boolean
        binary
        string
        text
        date
        time
        datetime
        ...
    ```

    ```bash
      ./run rails g model Item deleted:boolean type:enum by:string time:integer text:text dead:boolean parent:integer poll:integer url:text score:integer title:text

      # Note that we will need to add (via a migration)
      # kids, parts, and descendants
    ```

  1. **`id`**. Required. This is the HackerNews ID, not my DBs `id`. Or should it be the same as HN?

  2. `deleted`. Boolean. If an item is deleted or not.

  3. `type`. String. One of `"job"`, `"story"`, `"comment"`, `"poll"`, or `"pollopt"`.

  4. `by`. Username of items author.

  5. `time`. Creation date of the item, in Unix time.

  6. `text`. The comment, story, or poll text. HTML.
  
  7. `dead`. True if the item is dead.

  8. `parent`. The comment's parent: either another comment or the relevant story.

  9. `poll`. The pollopt's associated poll.

  10. `kids`. The ids of the item's comments, in ranked display order.

  11. `url`. The URL of the story.
  
  12. `score`. The story's score, or the votes for a pollopt.

  13. `title`. The title of the story, poll or job. HTML.
  
  14. `parts`. A list of related pollopts, in display order.

  15. `descendants`. In the case of stories or polls, the total comment count.

  TODO: List what fields we made and their types

  * [X] Create `Users` table that stores the following fields:

  1. **`id`**. The user's unique username. Case-sensitive. Required.

  2. **`created`**. Creation date of the user, in Unix Time.

  3. **`karma`**. The user's karma.

  4. `about`. The user's optional self-description. HTML.

  5. `submitted`. List of the user's stories, polls, and comments.

  TODO: Same as above

* [ ] Plan main page

  Should mimic news.ycombinator.com landing page. This will inform controller design and model relationships.

  It looks like the "Top" posts (i.e. the https://news.ycombinator.com/news) are a list of the top posts of the last 24 hours. If you click "More" at the bottom of the page, you navigate to the /news resource, but with a query param `p`. I am not sure if this list is generated on every request or if it is generated on an interval. If I implemented the code to do it on a time interval, I could use something like [sidekiq-scheduler](https://github.com/sidekiq-scheduler). However, I have a lot of questions regarding this solution, and it might be easier to start with just the code to generate the list, and come back to the issue of efficiency later.

  Btw, [here's](https://vigneshwarar.substack.com/p/hackernews-ranking-algorithm-how) a write-up on the ranking algorithm, which will be needed.

    * A **post** is just an _item_ in HN API.

  After looking at all of this, I've realized that perhaps the most sensible way to do this would be to store the data we want in a local DB, then query that for e.g. the top posts list. This way, I can re-query the DB on every request, and just have the database re-populated with new HN data on some customizable interval. So, that being said, I need to
  * verify postgres works and I know how to use it,
  * Determine how to update DB with Hackernews API data. Do I need all history? If I want a perfect mirror, yeah
    * Test to see how much data that would occupy. It will only grow.
  * get started with the ORM setup
