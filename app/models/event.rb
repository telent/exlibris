class Event < ActiveRecord::Base
  belongs_to :actor,:class_name=>"User"
  belongs_to :book
  belongs_to :recipient,:class_name=>"User"

  @@subscribers = []

  # create a new event and notify all event subscribers
  def self.publish(args)
    e=self.create(args)
    @@subscribers.each do |s|
      s.call e
    end
    e
  end

  def self.subscribe(callable)
    raise "argument must be callable" unless callable.respond_to?(:call)
    @@subscribers << callable
    callable
  end

  def self.unsubscribe(callable)
    @@subscribers.delete(callable)
  end

  validates_each :action do |r,a,v|
    Event.const_defined?(v.capitalize) or r.errors.add a,'Unrecognised action'
  end
  def action=(act)
    write_attribute(:action,act.to_s)
  end
  def action
    read_attribute(:action).to_sym
  end

  class Join;end
  class New;end
  class Review;end
  class Read;end
  class Request;end
  class Lend;end
  class Return;end

end
