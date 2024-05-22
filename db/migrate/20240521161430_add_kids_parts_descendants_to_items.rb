# frozen_string_literal: true

class AddKidsPartsDescendantsToItems < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    add_column :items, :kids, :integer, array: true, default: []
    add_column :items, :parts, :integer, array: true, default: []
    add_column :items, :descendants, :integer, array: true, default: []
  end
end
