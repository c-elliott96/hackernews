# frozen_string_literal: true

class AddSubmittedToUsers < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    add_column :users, :submitted, :integer, array: true, default: []
  end
end
