require "minitest_helper"

class EventTest < MiniTest::Rails::Model
  it "must have recognised action" do
    e=Event.new(:action=>"Lend")
    assert e.valid?
    e=Event.new(:action=>"Blend")
    refute e.valid?
  end
end
