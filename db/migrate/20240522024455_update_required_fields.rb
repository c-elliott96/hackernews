# frozen_string_literal: true

class UpdateRequiredFields < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    change_column_null :items, :context, false
    change_column_null :users, :hn_id, false
    change_column_null :users, :created, false
    change_column_null :users, :karma, false
  end
end
