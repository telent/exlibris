require_relative "../../lib/projectable"


class Book < ActiveRecord::Base
  belongs_to :owner,:class_name=>"User"
  belongs_to :borrower,:class_name=>"User"
  belongs_to :shelf
  belongs_to :edition

  def self.new_with_edition(attrs)
    author=attrs[:author]
    title=attrs[:title]
    if isbn=attrs[:isbn] then
      e=Edition.find_or_initialize_by_isbn(isbn)
      if e.id? then
        p=e.publication
      else
        p=Publication.find_or_create_by_author_and_title(author,title)
        e.publication=p
      end
    else
      e=Edition.new
      [:publisher,:isbn].each do |k|
        attrs[k].present? and e.send("#{k}=",attr[k])
      end
      p=Publication.find_or_create_by_author_and_title(author,title)
      e.publication=p
    end
    
    unless e.id? then
      [:publisher,:picture].each do |k|
        attrs[k].present? and e.send("#{k}=",attrs[k])
      end
      e.save
    end
    attrs[:edition]=e
    self.new attrs.project [:shelf,:shelf_id,:edition,:owner,:owner_id]
    
  end
  def title; self.edition.title ;end
  def author; self.edition.author ;end
  def isbn; self.edition.isbn ;end
  def publisher; self.edition.publisher ;end

end
