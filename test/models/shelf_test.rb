require "minitest_helper"

class ShelfTest < MiniTest::Rails::Model
  before do
    @shelf = Shelf.new
  end

  it "must be valid" do
    @shelf.valid?.must_equal true
  end


  # describe "when doing its thing" do
  #   it "must be interesting" do
  #     @shelf.blow_minds!
  #     @shelf.interesting?.must_equal true
  #   end
  # end
end
