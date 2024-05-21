class AddHackernewsIdToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :hn_id, :integer
  end
end
