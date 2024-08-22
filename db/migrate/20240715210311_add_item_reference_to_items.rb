class AddItemReferenceToItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :items, :parent_item, foreign_key: { to_table: :items }
  end
end
