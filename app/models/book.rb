class Book < ActiveRecord::Base
  belongs_to :owner
  belongs_to :borrower
  belongs_to :shelf
  belongs_to :edition
end
