class DeleteTypeInItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :type
    drop_enum :item_type
  end
end
