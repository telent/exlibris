# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111114160105) do

  create_table "authorizations", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id"], :name => "index_authorizations_on_user_id"

  create_table "books", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "borrower_id"
    t.integer  "shelf_id"
    t.integer  "edition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id"
    t.integer  "current_shelf_id"
  end

  add_index "books", ["borrower_id"], :name => "index_books_on_borrower_id"
  add_index "books", ["edition_id"], :name => "index_books_on_edition_id"
  add_index "books", ["owner_id"], :name => "index_books_on_owner_id"
  add_index "books", ["shelf_id"], :name => "index_books_on_shelf_id"

  create_table "collection_acls", :force => true do |t|
    t.integer  "collection_id"
    t.integer  "user_id"
    t.string   "permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collection_acls", ["collection_id"], :name => "index_collection_acls_on_collection_id"
  add_index "collection_acls", ["user_id"], :name => "index_collection_acls_on_user_id"

  create_table "collections", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["user_id"], :name => "index_collections_on_user_id"

  create_table "editions", :force => true do |t|
    t.string   "isbn"
    t.string   "publisher"
    t.integer  "publication_id"
    t.string   "picture"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "editions", ["publication_id"], :name => "index_editions_on_publication_id"

  create_table "events", :force => true do |t|
    t.integer  "actor_id"
    t.string   "action"
    t.integer  "book_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["actor_id"], :name => "index_events_on_owner_id"
  add_index "events", ["book_id"], :name => "index_events_on_book_id"
  add_index "events", ["recipient_id"], :name => "index_events_on_recipient_id"

  create_table "following", :force => true do |t|
    t.integer "follower_id"
    t.integer "following_id"
  end

  add_index "following", ["follower_id"], :name => "index_following_on_follower_id"
  add_index "following", ["following_id"], :name => "index_following_on_following_id"

  create_table "publications", :force => true do |t|
    t.string   "author"
    t.string   "title"
    t.string   "blurb"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "publication_id"
    t.integer  "reviewer_id"
    t.string   "author"
    t.string   "review_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["publication_id"], :name => "index_reviews_on_publication_id"
  add_index "reviews", ["reviewer_id"], :name => "index_reviews_on_reviewer_id"

  create_table "shelves", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shelves", ["owner_id"], :name => "index_shelves_on_owner_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "fullname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "email_address"
  end

end
