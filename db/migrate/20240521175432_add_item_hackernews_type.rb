# frozen_string_literal: true

class AddItemHackernewsType < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    create_enum :context_type, %w[job story comment poll pollopt]
    add_column :items, :context, :enum, enum_type: :context_type
  end
end
