class CreateFollowing < ActiveRecord::Migration
  def change
    create_table :following do |t|
      t.integer :follower_id
      t.integer :following_id
    end
    add_index :following, :follower_id
    add_index :following, :following_id
  end
end
