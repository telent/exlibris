require_relative "../../lib/projectable"


class Book < ActiveRecord::Base
  belongs_to :owner,:class_name=>"User"
  belongs_to :borrower,:class_name=>"User"
  belongs_to :shelf
  belongs_to :edition

  validates_associated :shelf
  validates_associated :edition
  validates_presence_of :edition

  def initialize(a={})
    keys=self.class.attribute_names.map(&:to_sym)
    if a[:isbn].present? then 
      e=Edition.find_by_isbn(a[:isbn])
    end
    if (a[:isbn].present? && 
        !a[:edition].present? &&
        !a[:author].present? &&
        !a[:title].present?) then
      if e.nil? then
        e=Edition.google_lookup_isbn(a[:isbn])
      end
      super(a.project(keys).merge(:edition=>e))
    elsif e && [:author,:title,:publisher].all? {|k| e.send(k)==a[k] } then
      super(a.project(keys).merge(:edition=>e))   
    else
      ks=(Edition.attribute_names+Publication.attribute_names).map(&:to_sym)
      e=Edition.new(a.project(ks))
      super(a.project(keys).merge(:edition=>e))   
    end
  end

  def self.newt_with_edition(attrs)
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
  def title; self.edition && self.edition.title ;end
  def author; self.edition && self.edition.author ;end
  def isbn; self.edition && self.edition.isbn ;end
  def publisher; self.edition && self.edition.publisher ;end

end
