class Event < ActiveRecord::Base
  validates_each :action do |r,a,v|
    Event.const_defined?(v.capitalize) or r.errors.add a,'Unrecognised action'
  end
  def action=(act)
    write_attribute(:action,act.to_s)
  end
  def action
    read_attribute(:action).to_sym
  end

  belongs_to :actor,:class_name=>"User"
  belongs_to :book
  belongs_to :recipient,:class_name=>"User"

  class Join;end
  class New;end
  class Review;end
  class Read;end
  class Request;end
  class Lend;end
  class Return;end

end
