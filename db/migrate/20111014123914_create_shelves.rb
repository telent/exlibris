class CreateShelves < ActiveRecord::Migration
  def change
    create_table :shelves do |t|
      t.string :name
      t.references :owner

      t.timestamps
    end
    add_index :shelves, :owner_id
  end
end
