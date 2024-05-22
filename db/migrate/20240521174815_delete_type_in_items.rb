# frozen_string_literal: true

class DeleteTypeInItems < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    remove_column :items, :type
    drop_enum :item_type
  end
end
