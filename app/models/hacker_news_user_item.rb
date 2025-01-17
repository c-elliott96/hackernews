# This class defines an object that represents User data from the HN API:
# GET https://hacker-news.firebaseio.com/v0/user/:username.json
# Some, most, or all of the fields defined in the parent class may not be
# present in the JSON
#
# TODO: submissions, comments, favorites
class HackerNewsUserItem < HackerNewsItem
  attr_accessor :about, :karma, :id, :created, :submitted
end
