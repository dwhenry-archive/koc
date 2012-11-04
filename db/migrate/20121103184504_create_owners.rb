class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.string :name
      t.references :team
      t.string :tags
      t.string :comments

      t.timestamps
    end
    add_index :owners, :team_id
  end
end
