require 'user'

class NewsfeedObserver < ActiveRecord::Observer
  observe :book,:user
  def after_create(model)
    warn [:after_create,model.class,model]
    if  model.is_a?(Book) then
      warn [:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa,model]
      ev=Event.create(:action=>:new,:actor=>model.owner,:book=>model)
    elsif model.is_a?(User) then
      ev=Event.create(:action=>:join,:actor=>model)
    end
  end
end
