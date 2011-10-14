class Edition < ActiveRecord::Base
  belongs_to :publication
  def title;    self.publication.title ;  end
  def author;    self.publication.author ;  end
end
