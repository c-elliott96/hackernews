class AddSubmittedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :submitted, :integer, array: true, default: []
  end
end
