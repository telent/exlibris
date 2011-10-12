class Review < ActiveRecord::Base
  belongs_to :publication
  belongs_to :reviewer
end
