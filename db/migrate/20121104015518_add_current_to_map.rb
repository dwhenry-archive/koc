class AddCurrentToMap < ActiveRecord::Migration
  def change
    add_column :maps, :current_version, :boolean
    add_index :maps, [:current_version, :x, :y]
  end
end
