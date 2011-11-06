class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :owner
      t.string :action
      t.references :book
      t.references :recipient

      t.timestamps
    end
    add_index :events, :owner_id
    add_index :events, :book_id
    add_index :events, :recipient_id
  end
end
