require_relative "../../lib/projectable"


class Book < ActiveRecord::Base
  belongs_to :owner,:class_name=>"User"
  belongs_to :borrower,:class_name=>"User"
  belongs_to :shelf
  belongs_to :edition

  validates_associated :shelf
  validates_associated :edition
  validates_presence_of :edition

  def initialize(a={},opts={})
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
      super(a.project(keys).merge(:edition=>e),opts)
    elsif e && [:author,:title,:publisher].all? {|k| e.send(k)==a[k] } then
      super(a.project(keys).merge(:edition=>e),opts)
    else
      ks=(Edition.attribute_names+Publication.attribute_names).map(&:to_sym)
      e=Edition.new(a.project(ks))
      super(a.project(keys).merge(:edition=>e),opts)
    end
  end

  def title; self.edition && self.edition.title ;end
  def author; self.edition && self.edition.author ;end
  def isbn; self.edition && self.edition.isbn ;end
  def publisher; self.edition && self.edition.publisher ;end

end
