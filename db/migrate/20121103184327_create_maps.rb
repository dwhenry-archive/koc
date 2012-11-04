class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.integer :x
      t.integer :y
      t.string :cell_type
      t.integer :level
      t.references :owner

      t.timestamps
    end
    add_index :maps, :owner_id
  end
end
