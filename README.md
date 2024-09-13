# hackernews

[Hackernews](https://news.ycombinator.com/) by Y Combinator, my way.

Leverages the [HackerNews API](https://github.com/HackerNews/API), and is
bootstrapped via the
[docker-rails-example](https://github.com/nickjj/docker-rails-example/tree/main)
project by [Nick Janetakis](https://nickjanetakis.com/). Please check out their
awesome work.

For details on the project's base Rails and Docker configurations, see the
[`docker-rails-example/README`](https://github.com/nickjj/docker-rails-example/blob/c2e3a4bec4bf355b1c6882f34dd74eb438035a50/README.md).

## Setup

Here are some steps necessary for running this project on a new device.

First, you should have Docker installed.

### Prepare the environment

1. Set up the environment variables in `.env`

   1. `cp .env.example .env`

   2. Edit `.env` with the following changes:

   ```diff
   55c55
   < export POSTGRES_USER=hello
   ---
   > export POSTGRES_USER=hackernews
   57,59c57,59
   < #export POSTGRES_DB=hello
   < #export POSTGRES_HOST=postgres
   < #export POSTGRES_PORT=5432
   ---
   > export POSTGRES_DB=hackernews
   > export POSTGRES_HOST=postgres
   > export POSTGRES_PORT=5432
   ```

2. Build the image and run it

   `docker compose build && docker compose run -d`

3. Setup the database

   `./run rails db:prepare`

## TODOs

See the project's ongoing list of TODOs in [TODO.md][todo.md]

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
  items = []
  threads = []
  ids.each_with_index do |id, i|
    threads << Thread.new do
      item = HackerNews.get(resource: :item, id:)
      items[i] = item
    end
  end
  threads.each(&:join)
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

* [2024-06-26 Wed]

  I added the story rank functionality. Now, stories in `/news` display the
  story's rank from HackerNews' `/topstories` resource.

  I also added the `More` button to load the next set of stories. This works by
  incrementing the `p` query param and making a `get` request to `/news`. A
  caveat: the resource we rely on only returns the top 500 stories. Page 16 of
  this list (in ranges of 30) ends at 480, so loading page 17 would attempt to
  load 481 - 510. I should add logic to the controller to truncate the results
  if we're at the end.

* [2024-06-28 Fri]

  I added the ability to view the secondary and top-level domain in parenthesis,
  like is done on HackerNews. However, it is currently just informational. On
  the actual website, it appears that this text is a hyperlink to a resource
  called `/from?site=...`, where the user is then directed to a list of all
  posts that reference that particular domain. I will need to figure out if
  doing this is possible and easy-enough.

  I also added the first piece of the secondary row of information about a
  particular story: the points, user, and story age description (e.g. `66 points
  by todsacerdoti 4 months ago`).

  I still need to implement the `hide` link, which apparently makes a request to
  `/hide` which I _think_ is an alias for `/snip-story`?

  ```text
  Request URL:
    https://news.ycombinator.com/snip-story?id=40817430&auth=106a51f53142f01a93cadd9014febd833fb21d51&onop=news
  Request Method:
    GET
  Status Code:
    200 OK
  ```

* [2024-07-13 Sat]

  Work on `/news` view. Mostly styling work. Lots of tailwind trial and error.

* [2024-07-14 Sun]

  Work on `/new` (renamed the url resource to "/newest", to reflect HN).
  Refactored to allow use of `items` partial for rendering a list of stories.
  Some other styling touch-ups.

  Start work on `/from`, which is reached by clicking the `past` link in the nav
  menu. Need to figure out how to create that list of stories.

* [2024-08-21 Wed]

  I've added a lot in this round of code changes. Too much to really document
  without spending a lot of time doing so. Iirc, most of the changes were
  related to getting some kind of views for all the navigation headers, and then
  a lot went into figuring out how to create the comment hierarchy for a given
  story.

  Something I've noticed is that when I render the HTML given to us by HN API
  for a comment Item, Tailwindcss is styling the HTML elements we render with
  the preflight configs. This breaks the styling in a variety of ways.
  Unfortunately, we still want the styling we've manually applied, but not the
  preflights. I haven't found an easy way to remedy this, so this item should be
  a TODO for down the line.

  Another issue is load times for large (> ~ 30 total) comment trees is pretty
  abysmal. This is due to the fact that I am making a new request for each level
  in a hierarchy. We are still taking advantage of threading all the "kids" of a
  particular item (using `ApplicationController::get_items_from_ids`), but each
  level of comments still has to wait on the previous. For large comment trees,
  this is _slow_. Without using a database, I am not sure how resolve this
  issue.

  I have a massive amount of `# TODO` comments in the code. Eventually I'll need
  to address them. I also need to refactor a _lot_. For example, I've made it so
  the `views/shared/_items` partial has a ton of `if` blocks to determine small
  styling details based on whether it's rendered in the main list of Items or a
  detail view of an item (with comments).
  
* [2024-09-12]

  I have made a lot of updates to this application, and have in some ways gotten
  nowhere. I had things in an ok state, using the HN API and just loading each
  story/comments by making a lot of network requests. Then, I got a new laptop
  with a good amount of free space, so I explored supporting a passively
  populated DB. Subsequently, I realized there was no way to get newly added
  comments to a story without re-requesting all of the children items in the
  Item's list (the HN API provides no way to find updated items, without
  constantly monitoring an opaque `/updates` endpoint). Doing so would render DB
  usage kind of pointless, as there would be no performance gain from only
  having to query the local DB as opposed to making new network requests.
  Moreover, I spent some time refactoring the primary controller
  (`ItemsController`) and related views in a more Rails-conventional manner. All
  of these changes currently exist in the now-abandoned
  [`consolidate_controllers`](https://github.com/c-elliott96/hackernews/tree/consolidate_controllers)
  branch, for reference. I am introducing _this_ update in the new
  `use-algolia-api` branch. I should be able to use the changes to views and
  controllers as a good reference, after I update the `hacker_news` service
  module to target the Algolia API instead. Finally, I'll need to rip out the
  database configurations in both Rails and the Docker set up, as it is not
  necessary and wouldn't be worth while to keep around. I can easily enough add
  it later if I want to.
  
  I have also moved my TODOs to [TODO.md][todo.md], to clean up this file. In
  doing so, I've been able to clean up the TODOs themselves.

---

I am using [GFM](https://github.github.com/gfm/) as the markdown specification
for this document. I do also format dates in here similarly to inactive
timestamps in Emacs' org-mode.

<!-- References -->
[todo.md]: TODO.md
