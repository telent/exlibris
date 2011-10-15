require "minitest_helper"

class EditionTest < MiniTest::Rails::Model
  before do
    @shelf = Edition.new
  end

  describe '#find_or_create_by_isbn' do
    it "should do Google Books API call if no edition found" do
      response_body=File.read(File.join(File.dirname(__FILE__),"../fixtures/spincontrol.json"))
      p=Patron::Session.new
      Patron::Session.expects(:new).returns(p)
      response=mock(:status=>200,:body=>response_body)
      p.expects(:get).returns(response)
      e=Edition.find_or_create_by_isbn("9-780553-586251")
      warn e
      assert_equal "Spin Control",e.title
      assert_equal "Spin Control",e.title
      assert_equal "Chris Moriarty",e.author
      assert_equal "Spectra", e.publisher
    end
  end

end
