require "minitest_helper"

class EditionTest < MiniTest::Rails::Model
  before do
    @author='Philip K. Dick'
    @title='Time Out Of Joint'
    @isbn='9780140171730'
    @publisher='RoC'
  end
  
  describe "#new" do
    it "generates a Publication" do
      p=mock
      p.stubs(:[]).with('id').returns(1)
      p.stubs(:is_a?).returns(Publication) # quack
      p.stubs(:class).returns(Publication) # quack        

      Publication.expects(:find_or_initialize_by_author_and_title).
        with(@author,@title).returns(p)
      e=Edition.new(:author=>@author,:title=>@title,:isbn=>@isbn,
                    :publisher=>@publisher)
      assert p,e.publication
    end
  end


  describe '#google_lookup_isbn' do
    it "does Google Books API call" do
      response_body=File.read(File.join(File.dirname(__FILE__),"../fixtures/spincontrol.json"))
      p=Patron::Session.new
      Patron::Session.expects(:new).returns(p)
      response=mock(:status=>200,:body=>response_body)
      p.expects(:get).returns(response)
      e=Edition.google_lookup_isbn("9-780553-586251")
      assert_equal "Spin Control",e.title
      assert_equal "Spin Control",e.title
      assert_equal "Chris Moriarty",e.author
      assert_equal "Spectra", e.publisher
    end
  end

end
