class TestController < ApplicationController
  # Controller for testing.
  def index
    # Current Goal: explore the two APIs: HackerNews and Algolia, and see if we
    # can serialize all of their datas into one, or a few, consistent Models.
    # Our back-end should not care which API the data comes from, and should be
    # able to refer to attributes consistently.

    hacker_news_item_story = {
      "by": "pg",
      "descendants": 15,
      "id": 1,
      "kids": [
        15,
        234509,
        487171,
        82729
      ],
      "score": 57,
      "time": 1160418111,
      "title": "Y Combinator",
      "type": "story",
      "url": "http://ycombinator.com"
    }

    hacker_news_item_comment = {
      "by": "throw16180339",
      "id": 42676818,
      "parent": 42671710,
      "text": "He threatened to sue the person behind bullenweg.com ...",
      "time": 1736715069,
      "type": "comment"
    }

    hacker_news_item_job = {
      "by": "nairtu",
      "id": 42672960,
      "score": 1,
      "time": 1736683338,
      "title": "Harper (YC W25) Is Hiring #1 Founding Growth/Operations Lead",
      "type": "job",
      "url": "https://www.ycombinator.com/companies/harper/jobs/VUe2K9r-founding-operations-lead"
    }

    hacker_news_item_poll = {
      "by": "zug_zug",
      "descendants": 4,
      "id": 42486443,
      "kids": [
          42486549,
          42486473,
          42486778,
          42486922
      ],
      "parts": [
          42486444,
          42486445,
          42486446,
          42486447
      ],
      "score": 2,
      "text": "In my personal experience -- from empire-building, to bad hires, to gaming metrics, to focusing on multi-quarter initiatives while things are on fire, I seem to find middle-managers &amp; directors are often the group who seem to be most often the issue at a bad company. This has been my experience about half of companies, from startup to faang.<p>Let&#x27;s see what the community at large thinks.<p>[Edit: To vote, click on an up-arrow below]",
      "time": 1734877083,
      "title": "Poll: Are middle-managers and directors the problem at where you work?",
      "type": "poll"
    }

    hacker_news_item_pollopt = {
      "by": "zug_zug",
      "id": 42486444,
      "poll": 42486443,
      "score": 2,
      "text": "Yes, most of the time",
      "time": 1734877083,
      "type": "pollopt"
    }

    # /search and /search_by_date return an array of "hits", among other
    # top-level fields. The "hits" are the items themselves. That is the
    # structure I have here, instead of the full REST response.
    algolia_search_by_date = {
      "_highlightResult": {
        "author": {
          "matchLevel": "none",
          "matchedWords": [],
          "value": "rntn"
        },
        "title": {
          "matchLevel": "none",
          "matchedWords": [],
          "value": "In Hokkaido, 'sea of mega solar farms' threatens protected park"
        },
        "url": {
          "matchLevel": "none",
          "matchedWords": [],
          "value": "https://www.asahi.com/ajw/articles/15539508"
        }
      },
      "_tags": [
        "story",
        "author_rntn",
        "story_42676956"
      ],
      "author": "rntn",
      "created_at": "2025-01-12T21:07:48Z",
      "created_at_i": 1736716068,
      "num_comments": 0,
      "objectID": "42676956",
      "points": 1,
      "story_id": 42676956,
      "title": "In Hokkaido, 'sea of mega solar farms' threatens protected park",
      "updated_at": "2025-01-12T21:08:48Z",
      "url": "https://www.asahi.com/ajw/articles/15539508"
    }

    # NOTE: Not all items in top_stories /are/ story items.

    # puts all_top_stories_are_stories?
  end

  def all_top_stories_are_stories?
    top_stories_ids = HackerNewsRequestor.new(api: :hn, resource: :top_stories).call[:data]
    top_stories = HackerNews::Utils.get_items_from_ids(top_stories_ids)
    top_stories.all? do |story|
      story.type == "story"
    end
  end
end
