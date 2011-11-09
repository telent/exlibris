class RenameEventOwnerToActor < ActiveRecord::Migration
  def change
    rename_column :events,:owner_id,:actor_id
  end
end
