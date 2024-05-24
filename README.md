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

  * [X] Create `Items` table

  * [X] Create `Users` table

  * [ ] Map HN API data to my tables.

  * [ ] Create worker task (or the like) to populate this DB with actual HN data.

  * [ ] Decide how much HN data we can hold on to.

* [ ] Populate DB with HN data, rather than requesting everything all the time. Is this a terrible decision?

  If we decide _not_ to have the data 'locally', we'll have to make requests for any piece that's not cached. Is caching a bad idea? How do? Oh man, if I didn't need the database after all...

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

## Database Implementation

See [Rails schema](/db/schema.rb) for current schema

### `Items` table

* `Item.hn_id` is a _unique, not null integer_. Corresponds to HackerNews API Item.id field.
* `Item.deleted` is a _boolean_. True if the item is deleted.
* `Item.context` is an _enum_. It corresponds to the HackerNews API User.type -- I changed it to avoid potentially causing issues with rails.
* `Item.by` is a _string_, most likely a `User.hn_id` (unique string).
* `Item.time` is an _integer_, but it represents Unix Time. It might need special treatment depending on what I need to do with it.
* `Item.text` is _text_ in DB, and represents HTML in HackerNews. "The comment, story, or poll text".
* `Item.dead` is a _boolean_. True if the item is dead (I don't presently know what that means).
* `Item.parent` is a has_one kind of relationship. Item only has one parent. Either another comment or the story. `Item.hn_id`.
* `Item.poll` is an _integer_, which should be `Item.hn_id`. Pollopt's associated poll.
* `Item.kids` is an _integer array_, that stores the `Item.hn_id`(s) of the items comments, in "ranked display order".
* `Item.url` is _text_. Url of the story.
* `Item.score` is an _integer_, reprenting the story's score... Meaning? It's also the votes for a `pollopt`.
* `Item.title` is _text_. The title of a story, poll, or job. HTML.
* `Item.parts` is an _integer array_, storing `Item.hn_id`(s) of pollopts in display order.
* `Item.descendants` is __currently__ an _integer array_, but I am not sure this is appropriate. "In the case of stories or polls, the total comment count." So maybe it should instead just be an integer.

### `Users` table

* `User.hn_id` is a _unique, not null string_. Corresponds to HackerNews API User.id field. Case sensitive.
* `User.created` is an _integer_, representing when the User was created in HN, in Unix Time. Same considerations for this field as Item.time.
* `User.karma` is an _integer_. "The user's karma."
* `User.about` is _text_. "The user's optional self-description. HTML."
* `User.submitted` is an _integer array_. "List of the user's stories, polls and comments." It should be a list of `Item.hn_id`(s).