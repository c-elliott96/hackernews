# frozen_string_literal: true

class AddHackernewsIdToItems < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    add_column :items, :hn_id, :integer
  end
end
