class Publication < ActiveRecord::Base
  validates :title,:author, :presence=>true
  def author_sortkey 
    # grievous western cultural assumptions
    names=self.author.split(",")[0].split(/ +/)
    names.last+", "+names[0..-2].join(" ")
  end
end
