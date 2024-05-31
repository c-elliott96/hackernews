class ChangeDescendantsToInteger < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :descendants
    add_column :items, :descendants, :integer
  end
end
