class User < ActiveRecord::Base
  has_many :shelves,:foreign_key=>:owner_id
  has_many :collections
  has_many :authorizations
  has_many :books, :through=>:shelves
end
