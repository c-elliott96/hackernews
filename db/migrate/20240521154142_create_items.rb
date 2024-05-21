class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_enum :item_type, %w[job story comment poll pollopt]
    create_table :items do |t|
      t.boolean :deleted
      t.enum :type, enum_type: :item_type
      t.string :by
      t.integer :time
      t.text :text
      t.boolean :dead
      t.integer :parent
      t.integer :poll
      t.text :url
      t.integer :score
      t.text :title

      t.timestamps
    end
  end
end
