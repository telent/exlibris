class CreateCollectionAcls < ActiveRecord::Migration
  def change
    create_table :collection_acls do |t|
      t.references :collection
      t.references :user
      t.string :permission

      t.timestamps
    end
    add_index :collection_acls, :collection_id
    add_index :collection_acls, :user_id
  end
end
