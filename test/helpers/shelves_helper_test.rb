require "minitest_helper"

class ShelvesHelperTest < MiniTest::Rails::Helper
  before do
    @helper= ShelvesHelper.new
  end

  it "must be a real test" do
    flunk "Need real tests"
  end
end
