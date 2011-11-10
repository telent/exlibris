require_relative "../minitest_helper"
require 'mocha'

class BookTest < MiniTest::Rails::Model
  before do
    @published=nil
    @esubscriber=Event.subscribe proc {|e| 
      @published=Hash[[:action,:actor,:book,:recipient].map{|m| [m,e.send(m)]}]
    }
    @user=User.create(:name=>"dan")
    @author='Philip K. Dick'
    @title='Time Out Of Joint'
    @isbn='9780140171730'
    @publisher='RoC'
    @shelf=Shelf.create(:owner=>@user,:name=>"A SHELF")
  end
  after do
    Event.unsubscribe @esubscriber
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
        assert_match "Edition missing", b.errors.full_messages.join
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
    it "when ISBN absent, makes new book and edition" do
      m2=mock_edition
      Edition.expects(:new).with(has_entry(:title=>@title)).returns(m2)
      b=Book.new(:author=>@author,:title=>@title,:publisher=>@publisher)
      m2.stubs(:valid?).returns(true)
      m2.stubs(:collect).returns []
      assert b.valid? #,b.errors.full_messages.join(" ")
    end
  end
  describe "#lend" do
    before do
      @borrower=User.new(:id=>-11,:name=>"borrower")
      m=mock_edition()
      Edition.expects(:find_by_isbn).with(@isbn).returns(m)
      m.stubs(:save)
      m.stubs(:new_record?)
      m.stubs(:destroyed?)
      m.stubs(:valid?).returns(true)
      m.stubs(:collect).returns []
      
      @book=Book.create(:isbn=>@isbn,:owner=>@user,:shelf=>@shelf)
    end
    
    it "can be lent if on shelf" do
      @book.lend(@borrower)
      assert_equal @borrower, @book.borrower
      assert @book.on_loan?

      assert_equal :lend,@published[:action]
      assert_equal @book,@published[:book]
      assert_equal @user,@published[:actor]
      assert_equal @borrower,@published[:recipient]
    end
    
    it "can be returned if lent" do
      @book.lend(@borrower)
      @book.return
      refute @book.on_loan?
      assert_equal :return,@published[:action]
      assert_equal @book,@published[:book]
      assert_equal @borrower,@published[:actor]
    end
    
    it "can't be lent to its owner" do
      assert_raises(Exception) {
        @book.lend(@book.owner)
      }
      refute @book.on_loan?
    end
    
    it "cannot be lent if already on loan" do  
      @thief=User.new(:id=>-12,:name=>"borrower 3")
      @book.lend(@borrower)
      assert_raises(Exception) {
        @book.lend(@thief)
      }
      assert_equal @borrower, @book.borrower
    end
  end
  describe "#save" do
    it "should create an event when a new book is saved" do
      m=mock_edition
      Edition.expects(:find_by_isbn).with(@isbn).returns(m)
      [:save,:destroyed?,:new_record?].each do |meth| 
        m.stubs meth
      end
      m.stubs(:collect).returns []
      s=Shelf.new(:owner=>@user)
      b=Book.create(:isbn=>@isbn,:shelf=>s)
      assert_equal :new,@published[:action]
      assert_equal b,@published[:book]
      assert_equal @user,@published[:actor]

    end
  end
end
       
