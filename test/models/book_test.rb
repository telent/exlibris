require "minitest_helper"
require 'mocha'

class BookTest < MiniTest::Rails::Model
  before do
    @user=User.new(:id=>-10,:name=>"dan")
    @author='Philip K. Dick'
    @title='Time Out Of Joint'
    @isbn='9780140171730'
    @publisher='RoC'
  end
  
  def mock_edition
    e=mock(:title=>@title,:author=>@author,
                 :isbn=>@isbn,:publisher=>@publisher)
    e.expects(:[]).with('id').returns(1)
    e.expects(:is_a?).returns(Edition) # quack
    e.expects(:class).returns(Edition) # quack        
    e
  end


  describe "#new" do
    describe "when isbn provided and no author/title" do
      it "uses existing Edition where ISBN matches" do
        Edition.expects(:find_by_isbn).with(@isbn).returns(mock_edition)
        b=Book.new(:isbn=>@isbn,:owner=>@user)
        assert_equal @title,b.title
        assert_equal @author,b.author
        assert_equal @isbn,b.isbn
        assert_equal @publisher,b.publisher
      end
      it "creates new Edition when the ISBN exists in Google Books" do
        Edition.expects(:find_by_isbn).with(@isbn).returns(nil)
        Edition.expects(:google_lookup_isbn).with(@isbn).returns(mock_edition)
        b=Book.new(:isbn=>@isbn,:owner=>@user)
        assert_equal @title,b.title
        assert_equal @author,b.author
        assert_equal @isbn,b.isbn
        assert_equal @publisher,b.publisher
      end
      it "creates invalid Book when ISBN is invalid or not found" do
        Edition.expects(:find_by_isbn).with(@isbn).returns(nil)
        Edition.expects(:google_lookup_isbn).with(@isbn).returns(nil)
        b=Book.new(:isbn=>@isbn,:owner=>@user)
        refute b.valid?
        assert_match "Edition can't be blank", b.errors.full_messages.join
      end
    end
    describe "when ISBN provided and author/title exists" do
      it "uses existing Edition if author/title/publisher match"
      it "creates new Edition with same ISBN otherwise"
    end
    it "when ISBN absent, creates new book"
  end
end
        
