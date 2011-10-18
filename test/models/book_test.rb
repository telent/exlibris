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
    e=mock
    e.stubs(:title=>@title,:author=>@author,
           :isbn=>@isbn,:publisher=>@publisher,
            :id=>1)
    e.stubs(:[]).with('id').returns(1)
    e.stubs(:is_a?).returns(Edition) # quack
    e.stubs(:class).returns(Edition) # quack        
    e
  end

  def mock_edition2
    e=mock
    e.stubs(:title=>nil,:author=>nil,:isbn=>nil,:publisher=>nil,:id=>2)
    e.stubs(:[]).with('id').returns(2)
    e.stubs(:is_a?).returns(Edition) # quack
    e.stubs(:class).returns(Edition) # quack        
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
    describe "when ISBN and author/title all provided" do
      it "uses existing Edition if author/title/publisher match" do
        Edition.expects(:find_by_isbn).with(@isbn).returns(mock_edition)
        b=Book.new(:author=>@author,:title=>@title,:isbn=>@isbn,
                   :publisher=>@publisher)
        assert_equal mock_edition.id,b.edition.id
        assert_equal @title,b.title
        assert_equal @author,b.author
        assert_equal @isbn,b.isbn
        assert_equal @publisher,b.publisher
      end
      it "creates new Edition with same ISBN otherwise" do
        Edition.expects(:find_by_isbn).with(@isbn).returns(mock_edition)
        m2=mock_edition2
        Edition.expects(:new).with() {|a|
          a[:author]=="Not #{@author}"
        }.returns(m2)
        b=Book.new(:author=>"Not #{@author}",:title=>@title,:isbn=>@isbn,
                   :publisher=>@publisher)
        assert_equal b.edition,m2
      end
    end
    it "when ISBN absent, creates new book" do
      b=Book.new(:author=>"Not #{@author}",:title=>@title,:publisher=>@publisher)
      assert b.valid?
    end
  end
end
        
