class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.primary_key :id
      t.references :owner
      t.references :borrower
      t.references :shelf
      t.references :edition

      t.timestamps
    end
    add_index :books, :owner_id
    add_index :books, :borrower_id
    add_index :books, :shelf_id
    add_index :books, :edition_id
  end
end
