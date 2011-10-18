require "minitest_helper"

class SessionsHelperTest < MiniTest::Rails::Helper
  before do
    @helper= SessionsHelper.new
  end

  it "must be a real test" do
    flunk "Need real tests"
  end
end
