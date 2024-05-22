# frozen_string_literal: true

class UpdateItemsNullables < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    change_column_null :items, :hn_id, false
    change_column_null :items, :context, true # erroneous in the first place
  end
end
