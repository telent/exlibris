require "minitest_helper"

class EventTest < MiniTest::Rails::Model
  it "must have recognised action" do
    e=Event.new(:action=>"Lend")
    assert e.valid?
    e=Event.new(:action=>"Blend")
    refute e.valid?
  end
  it "calls registered subscribers when an event is pushed" do
    succeeded=false
    Event.subscribe proc { succeeded=true }
    Event.publish(action: :join, actor: User.create(name: "hellO" ))
    assert succeeded
  end
end
