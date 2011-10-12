class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.string :isbn
      t.string :publisher
      t.references :publication
      t.string :picture

      t.timestamps
    end
    add_index :editions, :publication_id
  end
end
