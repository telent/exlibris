require "minitest_helper"

class AuthorizationTest < MiniTest::Rails::Model
  before do
    @authorization = Authorization.new
  end

  it "must be valid" do
    @authorization.valid?.must_equal true
  end

end
