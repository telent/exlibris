class Shelf < ActiveRecord::Base
  belongs_to :owner,:class_name=>"User"
  has_many :books

  def permitted?(user,permissiom)
    (user == self.owner)
  end

end
