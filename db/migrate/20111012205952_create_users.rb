class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.primary_key :id
      t.string :name
      t.string :fullname

      t.timestamps
    end
  end
end
