class TestController < ApplicationController
  # Controller for testing.
  def index
    # Current Goal: explore the two APIs: HackerNews and Algolia, and see if we
    # can serialize all of their datas into one, or a few, consistent Models.
    # Our back-end should not care which API the data comes from, and should be
    # able to refer to attributes consistently.

    # HackerNews Items (Items may be of type [job, story, comment, poll, pollopt])

    top_stories_by_date
    return

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

    # Algolia REST JSON (/items, /users, /search, /search_by_date)

    # items response that doesn't include children
    algolia_items_no_children = {
      "author": "pc",
      "children": [],
      "created_at": "2007-02-19T18:38:08.000Z",
      "created_at_i": 1171910288,
      "id": 100,
      "options": [],
      "parent_id": nil,
      "points": 6,
      "story_id": 100,
      "text": nil,
      "title": "SpikeSource, CA-based startup, becomes Ubuntu commercial support provider for US",
      "type": "story",
      "url": "http://www.linux-watch.com/news/NS7616991195.html"
    }

    algolia_items_with_children = {
      "author": "pg",
      "children": [
        {
          "author": "sama",
          "children": [
            {
              "author": "pg",
              "children": [
                {
                  "author": "dmon",
                  "children": [],
                  "created_at": "2007-02-25T22:18:23.000Z",
                  "created_at_i": 1172441903,
                  "id": 1079,
                  "options": [],
                  "parent_id": 17,
                  "points": nil,
                  "story_id": 1,
                  "text": "sure",
                  "title": nil,
                  "type": "comment",
                  "url": nil
                }
              ],
              "created_at": "2006-10-09T19:52:45.000Z",
              "created_at_i": 1160423565,
              "id": 17,
              "options": [],
              "parent_id": 15,
              "points": nil,
              "story_id": 1,
              "text": "Is there anywhere to eat on Sandhill Road?",
              "title": nil,
              "type": "comment",
              "url": nil
            }
          ],
          "created_at": "2006-10-09T19:51:01.000Z",
          "created_at_i": 1160423461,
          "id": 15,
          "options": [],
          "parent_id": 1,
          "points": nil,
          "story_id": 1,
          "text": "&#34;the rising star of venture capital&#34; -unknown VC eating lunch on SHR",
          "title": nil,
          "type": "comment",
          "url": nil
        }
        # Removed a child with a ton of nested children
      ],
      "created_at": "2006-10-09T18:21:51.000Z",
      "created_at_i": 1160418111,
      "id": 1,
      "options": [],
      "parent_id": nil,
      "points": 57,
      "story_id": 1,
      "text": nil,
      "title": "Y Combinator",
      "type": "story",
      "url": "http://ycombinator.com"
    }

    algolia_users = {
      "about": "Bug fixer.",
      "karma": 157316,
      "username": "pg"
    }

    algolia_search = {
      "exhaustive": {
        "nbHits": false,
        "typo": true
      },
      "exhaustiveNbHits": false,
      "exhaustiveTypo": true,
      "hits": [
        {
          "_highlightResult": {
            "author": {
              "matchLevel": "none",
              "matchedWords": [],
              "value": "philliphaydon"
            },
            "title": {
              "fullyHighlighted": false,
              "matchLevel": "full",
              "matchedWords": [
                "hello"
              ],
              "value": "Bye Bye Mongo, <em>Hello</em> Postgres"
            },
            "url": {
              "fullyHighlighted": false,
              "matchLevel": "full",
              "matchedWords": [
                "hello"
              ],
              "value": "https://www.theguardian.com/info/2018/nov/30/bye-bye-mongo-<em>hello</em>-postgres"
            }
          },
          "_tags": [
            "story",
            "author_philliphaydon",
            "story_18717168"
          ],
          "author": "philliphaydon",
          "children": [
            18717600,
            18717643,
            18717838,
            18717922,
            18718068,
            18718154,
            18718192,
            18718207,
            18718210,
            18718364,
            18718431,
            18718447,
            18718448,
            18718483,
            18718484,
            18718488,
            18718567,
            18718593,
            18718858,
            18718869,
            18718953,
            18719035,
            18719132,
            18719135,
            18719160,
            18719195,
            18719247,
            18719259,
            18719270,
            18719336,
            18719460,
            18719650,
            18719659,
            18719678,
            18720043,
            18720134,
            18720157,
            18720194,
            18720807,
            18720830,
            18720855,
            18720875,
            18721230,
            18721356,
            18721462,
            18721544,
            18721548,
            18721702,
            18721866,
            18722375,
            18722884,
            18723458,
            18723573,
            18723633,
            18723681,
            18723921
          ],
          "created_at": "2018-12-19T17:08:53Z",
          "created_at_i": 1545239333,
          "num_comments": 417,
          "objectID": "18717168",
          "points": 1562,
          "story_id": 18717168,
          "title": "Bye Bye Mongo, Hello Postgres",
          "updated_at": "2024-11-21T14:24:44Z",
          "url": "https://www.theguardian.com/info/2018/nov/30/bye-bye-mongo-hello-postgres"
        }
      ],
      "hitsPerPage": 1,
      "nbHits": 59380,
      "nbPages": 1000,
      "page": 0,
      "params": "query=%22hello%22&hitsPerPage=1&advancedSyntax=true&analyticsTags=backend",
      "processingTimeMS": 2,
      "processingTimingsMS": {
        "_request": {
          "roundTrip": 13
        },
        "afterFetch": {
          "merge": {
            "total": 1
          },
          "total": 1
        },
        "fetch": {
          "scanning": 1
        },
        "total": 2
      },
      "query": "\"hello\"",
      "serverTimeMS": 2
    }

    # /search and /search_by_date return an array of "hits", among other
    # top-level fields. The "hits" are the items themselves. That is the
    # structure I have here, instead of the full REST response.
    algolia_search_by_date = {
      "exhaustive": {
        "nbHits": false,
        "typo": true
      },
      "exhaustiveNbHits": false,
      "exhaustiveTypo": true,
      "hits": [
        {
          "_highlightResult": {
            "author": {
              "matchLevel": "none",
              "matchedWords": [],
              "value": "philliphaydon"
            },
            "title": {
              "fullyHighlighted": false,
              "matchLevel": "full",
              "matchedWords": [
                "hello"
              ],
              "value": "Bye Bye Mongo, <em>Hello</em> Postgres"
            },
            "url": {
              "fullyHighlighted": false,
              "matchLevel": "full",
              "matchedWords": [
                "hello"
              ],
              "value": "https://www.theguardian.com/info/2018/nov/30/bye-bye-mongo-<em>hello</em>-postgres"
            }
          },
          "_tags": [
            "story",
            "author_philliphaydon",
            "story_18717168"
          ],
          "author": "philliphaydon",
          "children": [
            18717600,
            18717643,
            18717838,
            18717922,
            18718068,
            18718154,
            18718192,
            18718207,
            18718210,
            18718364,
            18718431,
            18718447,
            18718448,
            18718483,
            18718484,
            18718488,
            18718567,
            18718593,
            18718858,
            18718869,
            18718953,
            18719035,
            18719132,
            18719135,
            18719160,
            18719195,
            18719247,
            18719259,
            18719270,
            18719336,
            18719460,
            18719650,
            18719659,
            18719678,
            18720043,
            18720134,
            18720157,
            18720194,
            18720807,
            18720830,
            18720855,
            18720875,
            18721230,
            18721356,
            18721462,
            18721544,
            18721548,
            18721702,
            18721866,
            18722375,
            18722884,
            18723458,
            18723573,
            18723633,
            18723681,
            18723921
          ],
          "created_at": "2018-12-19T17:08:53Z",
          "created_at_i": 1545239333,
          "num_comments": 417,
          "objectID": "18717168",
          "points": 1562,
          "story_id": 18717168,
          "title": "Bye Bye Mongo, Hello Postgres",
          "updated_at": "2024-11-21T14:24:44Z",
          "url": "https://www.theguardian.com/info/2018/nov/30/bye-bye-mongo-hello-postgres"
        }
      ],
      "hitsPerPage": 1,
      "nbHits": 59380,
      "nbPages": 1000,
      "page": 0,
      "params": "query=%22hello%22&hitsPerPage=1&advancedSyntax=true&analyticsTags=backend",
      "processingTimeMS": 2,
      "processingTimingsMS": {
        "_request": {
          "roundTrip": 13
        },
        "afterFetch": {
          "merge": {
            "total": 1
          },
          "total": 1
        },
        "fetch": {
          "scanning": 1
        },
        "total": 2
      },
      "query": "\"hello\"",
      "serverTimeMS": 2
    }

    objects = [
      ["hacker_news_item_story", hacker_news_item_story.sort_by { |key, _| key }.to_h],
      ["hacker_news_item_comment",hacker_news_item_comment.sort_by { |key, _| key }.to_h],
      ["hacker_news_item_job", hacker_news_item_job.sort_by { |key, _| key }.to_h],
      ["hacker_news_item_poll", hacker_news_item_poll.sort_by { |key, _| key }.to_h],
      ["hacker_news_item_pollopt",hacker_news_item_pollopt.sort_by { |key, _| key }.to_h]
      # ["algolia_items_no_children",algolia_items_no_children.sort_by { |key, _| key }.to_h],
      # ["algolia_items_with_children",algolia_items_with_children.sort_by { |key, _| key }.to_h],
      # ["algolia_users",algolia_users.sort_by { |key, _| key }.to_h],
      # ["algolia_search",algolia_search.sort_by { |key, _| key }.to_h],
      # ["algolia_search_by_date",algolia_search_by_date.sort_by { |key, _| key }.to_h]
    ]

    hacker_news_fields = [ "id", "deleted", "type", "by", "time", "text",
    "dead", "parent", "poll", "kids", "url", "score", "title", "parts",
    "descendants" ].sort

    front_padding = "hacker_news_item_pollopt".length + 2
    header_string = hacker_news_fields.join(" | ")
    header_len = header_string.length + front_padding
    (header_len + 2).times { print("-") }
    puts ""
    front_padding.times { print(" ") }
    print("#{header_string} |")
    puts ""
    (header_len + 2).times { print("-")}
    puts ""
    objects.each do |obj|
      print(obj[0])
      (front_padding - 1 - obj[0].length).times { print(" ") }
      hacker_news_fields.each do |field|
        print(" ")
        if obj[1].key? field.to_sym
          field.length.times { print("X") }
        else
          field.length.times { print(".") }
        end
        print(" |")
      end
      puts ""
      (header_len + 2).times { print("-") }
      puts ""
    end

    # objects.each do |api_res|
    #   puts api_res[0]
    #   api_res[1].each_key do |key|
    #     print("\t#{key}")
    #   end
    #   puts ""
    # end
    # STDOUT.flush

    # NOTE: Not all items in top_stories /are/ story items.

    # puts all_top_stories_are_stories?
  end

  # This was for investigating whether we could use topstories for /past, but it
  # doesn't matter as we can't query topstories for specific dates.
  def top_stories_by_date
    topstories = HackerNewsRequestor.new(api: :hn, resource: :top_stories).call[:data]
    items = HackerNews::Utils.get_items_from_ids(topstories)
    items.each do |item|
      if Time.at(item.time).between?(Date.current.yesterday.all_day)
        puts Time.at(item.time)
      end
    end
  end

  def all_top_stories_are_stories?
    top_stories_ids = HackerNewsRequestor.new(api: :hn, resource: :top_stories).call[:data]
    top_stories = HackerNews::Utils.get_items_from_ids(top_stories_ids)
    top_stories.all? do |story|
      story.type == "story"
    end
  end

  def print_field_comparison_table(fields, rows)
  end
end
