require_relative "../../lib/projectable"

class Book < ActiveRecord::Base
  has_one :owner,:class_name=>"User", :through=>:shelf
  belongs_to :borrower,:class_name=>"User"
  belongs_to :shelf
  belongs_to :edition
  belongs_to :collection

  validates_associated :shelf
  validates_associated :edition
  # rails seems not to be terribly good at validating associations when
  # the associated object is unsaved.  ENTRAILS ON A STICK
  # validates :edition_id,:presence=>true 
  validate :edition_exists
  def edition_exists 
    unless (self.edition || self.edition_id.present?) then
      errors.add(:edition, "missing")
    end
  end

  def cover_image_url(size=:small)
    "http://covers.openlibrary.org/b/isbn/#{self.isbn}-#{size.to_s[0].upcase}.jpg"
  end

  def initialize(attr={},opts={})
    keys=self.class.attribute_names.map(&:to_sym)
    a=Hash[attr.map {|k,v| [k.to_sym,v]}]
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
      super(a.project(keys).merge(:edition=>e),opts)
    elsif e && [:author,:title,:publisher].all? {|k| e.send(k)==a[k] } then
      super(a.project(keys).merge(:edition=>e),opts)
    else
      ks=(Edition.attribute_names+Publication.attribute_names).map(&:to_sym)
      e=Edition.new(a.project(ks))
      super(a.project(keys).merge(:edition=>e),opts)
    end
  end

  def lend(borrower)
    if self.borrower then
      raise Exception,"Can't loan to two people at once"
    elsif borrower==self.owner then
      raise Exception,"Can't lend to owner"
    else
      self.borrower=borrower
      save
    end
  end

  def on_loan?
    !! borrower
  end
    
  def return
    self.borrower=nil
    self.save
  end
  
  def title; self.edition && self.edition.title ;end
  def author; self.edition && self.edition.author ;end
  def author_sortkey; self.edition && self.edition.author_sortkey ;end
  def isbn; self.edition && self.edition.isbn ;end
  def publisher; self.edition && self.edition.publisher ;end

  before_save :save_edition

  private
  def save_edition
    e=self.edition and e.save
  end

end
