# This controller is responsible for rendering a user, in the form of a
# HackerNewsUserItem. It replicates the view from HackerNews when you click on a
# specific user profile.
#
# Route: /user/ => users#show
#
# View render sequence: `layouts/application` > `users/show` > `shared/nav`,
# `shared/algolia_show_user`
class UsersController < ApplicationController
  def show
    id = params[:id]
    item_res_data = HackerNewsRequestor.new(api: :hn, resource: :user, id:)
                                       .call[:data]
    @item = HackerNewsUserItem.new(item_res_data)
    @item.create
  end
end
