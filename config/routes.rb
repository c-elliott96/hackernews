# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "news#index"

  # The action that runs when you select an item
  get "/item/", to: "news#show", as: :show_item

  get "/news/", to: "news#index"

  get "/newest/", to: "new#index", as: :new

  get "/front/", to: "past#index", as: :past

  get "/newcomments/", to: "comments#index", as: :comments

  get "/ask/", to: "ask#index", as: :ask

  get "/show/", to: "show#index", as: :show
  # get "/show/:id", to: "show#show", as: :show_item

  get "/jobs/", to: "jobs#index", as: :jobs

  get "/user/", to: "users#show", as: :user

  # Render generic "not implementable" page
  get "/submit/", to: "submit#index", as: :submit

  get "/up/", to: "up#index", as: :up
  get "/up/databases", to: "up#databases", as: :up_databases

  # testing purposes
  get "test", to: "test#index"

  # Sidekiq has a web dashboard which you can enable below. It's turned off by
  # default because you very likely wouldn't want this to be available to
  # everyone in production.
  #
  # Uncomment the 2 lines below to enable the dashboard WITHOUT authentication,
  # but be careful because even anonymous web visitors will be able to see it!
  # require "sidekiq/web"
  # mount Sidekiq::Web => "/sidekiq"
  #
  # If you add Devise to this project and happen to have an admin? attribute
  # on your user you can uncomment the 4 lines below to only allow access to
  # the dashboard if you're an admin. Feel free to adjust things as needed.
  # require "sidekiq/web"
  # authenticate :user, lambda { |u| u.admin? } do
  #   mount Sidekiq::Web => "/sidekiq"
  # end

  # Learn more about this file at: https://guides.rubyonrails.org/routing.html
end
