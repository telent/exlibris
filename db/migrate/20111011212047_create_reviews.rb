class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :publication
      t.references :reviewer
      t.string :author
      t.string :review_text

      t.timestamps
    end
    add_index :reviews, :publication_id
    add_index :reviews, :reviewer_id
  end
end
