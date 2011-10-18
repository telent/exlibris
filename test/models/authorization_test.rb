require "minitest_helper"

class AuthorizationTest < MiniTest::Rails::Model
  before do
    @authorization = Authorization.new
  end

  it "must be valid" do
    @authorization.valid?.must_equal true
  end

  it "must be a real test" do
    flunk "Need real tests"
  end

  # describe "when doing its thing" do
  #   it "must be interesting" do
  #     @authorization.blow_minds!
  #     @authorization.interesting?.must_equal true
  #   end
  # end
end