class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :hn_id
      t.integer :created
      t.integer :karma
      t.text :about

      t.timestamps
    end
  end
end
