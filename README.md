# hackernews

[Hackernews](https://news.ycombinator.com/) by Y Combinator, my way.

Leverages the [HackerNews API](https://github.com/HackerNews/API), and is bootstrapped via the [docker-rails-example](https://github.com/nickjj/docker-rails-example/tree/main) project by [Nick Janetakis](https://nickjanetakis.com/). Please check out their awesome work.

For details on the project's base Rails and Docker configurations, see the [`docker-rails-example/README`](https://github.com/nickjj/docker-rails-example/blob/c2e3a4bec4bf355b1c6882f34dd74eb438035a50/README.md).

## TODOs

My list of WIP TODOs. Peridically sort these by priority!

* [ ] In-Progress: `/news` (root)

  Renders some group of 30 posts from `/topstories`. Accepts query param `p` to know what group to display.

* [ ] Fix `./run ruby-lint -a` to work properly.

* [ ] Add some kind of CVE/deprecation scanner to keep dependencies up to date. Or figure out how to cleanly rebase from `docker-rails-example`.

* [ ] Update tests and add to reflect changes to `HackerNews.get`

* [ ] Handle future API changes properly

  > For versioning purposes, only removal of a non-optional field or alteration of an existing field will be considered incompatible changes. Clients should gracefully handle additional fields they don't expect, and simply ignore them.

### Completed/Archived

* [x] Plan main page

  Should mimic news.ycombinator.com landing page. This will inform controller design and model relationships.

  Btw, [here's](https://vigneshwarar.substack.com/p/hackernews-ranking-algorithm-how) a write-up on the ranking algorithm, which will be needed.
  
  What _is_ the HN main page API endpoint, or sorting method? It's not immediately clear. Let's make up something and move on. Since the HN API talks about `/topstories` first, that's what I'm going to do.

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
    
    To delete all content from a table via psql interface: `TRUNCATE tablename RESTART IDENTITY CASCADE;`. This command is the preferred way to delete rows, and restarts auto-incrementing counters. The cascade directive says to remove references to the deleted items.

  * [X] Determine how to create tables in Rails

    `./run rails g model ExampleModel` for creating a model and `./run rails g migration` to create a migration

  * [X] Create `Items` table

  * [X] Create `Users` table

  * [ ] Create worker task (or the like) to populate this DB with actual HN data.

  * [ ] Decide how much HN data we can hold on to.

* [ ] Populate DB: Rake tasks

  Plan: rake tasks to keep DB mirror of HN in sync as often as feasible
  
  Max history configuration? I.e., do we create a way for us to only mirror a portion of the DB, as opposed to the whole thing? This would be ideal for development and deployment testing.
  
  1. Check if DB is out of sync. What tables are we mirroring?
  2. Sync DB. Spawn worker thread to update DB. Make sure we aren't locking the DB during this whole thread, only on writes to the database.
  
  What if instead of attempting to mirror the whole DB, I just start adding "encountered" items to the DB passively? Then, as a user navigates, we first check if the item exists in our local db. If not, we request it and add it to the DB.

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

## Development Changes

Note: This subsection should be replaced by the CHANGELOG when I release an
initial version.

* [2024-05-29] 

  I added a log WARN message to HackerNews.get if we attempt to access a
  resource that returns `nil` for the response body. This shouldn't happen, but
  it seems like I can't rely on the response code because even bad item IDs
  result in a `res.code` of 200.

  I also started work on adding a temporary utility script that I'll use to
  populate the DB with a small subset of items, to try to get a feel for how
  much data the whole HN dump will consume.
  [This](https://news.ycombinator.com/item?id=38861301) post seems to indicate
  that the dataset should be ~5-6GB.
  
* [2024-06-23 Sun] -- [2024-06-25 Tue] 

  I've decided not to worry about the database stuff yet. I've spent too much
  time trying to figure out how best to do that, and too little developing. For
  now, let's just make a fresh request for every new resource we need. Later we
  can adding caching/DB support to improve things. I'll leave the DB setup as
  is, unused.
  
  Adding code like the following improved response times considerably:
  
  ```ruby
  def index
    all_top_stories = HackerNews.get(resource: :top_stories)[:data]
    # array of ids for the top stories of a given range
    top_stories_page_p = all_top_stories.slice(@page_range)
    @stories = []
    threads = []
    top_stories_page_p.each_with_index do |id, index|
      threads << Thread.new do
        story_data = HackerNews.get(resource: :item, id:)[:data]
        @stories[index] = [story_data[:title], story_data[:url]]
      end
    end
    threads.each(&:join)
  end
  ```
  
  Where we went from getting story details for 30 items in about 5-7 seconds to
  doing so in about 0.5 - 2 seconds. Adding threads for these requests was a
  good choice, it seems. I did attempt to take things a step further in that I
  wrote some code to first check if the requested item exists in the local
  database (and just return that), and otherwise we can make the request and
  then SAVE the item to the DB (whereby passively populating our own database).
  However, doing so in the same async manner caused my code to create a large
  number of DB actions at once (since initially there are no items in the DB),
  overwhelming the thread pool for the database. A solution to this immediate
  issue is to increase the pool configuration number. However, I'm not sure if
  that's sufficient. With many concurrent users, this could crash things. I will
  either need to create some kind of protection layer around this, or abandon
  this idea for now. The latter is what I'm going with for the time being, as I
  would like to come back to DB/cache optimization after I get a v0 application
  completed.

---

I am using [GFM](https://github.github.com/gfm/) as the markdown specification
for this document. I do also format dates in here similarly to inactive
timestamps in Emacs' org-mode.
