require "minitest_helper"
require 'mocha'

class BookTest < MiniTest::Rails::Model
  before do
    @book = Book.new
  end

  it "must be valid" do
    @book.valid?.must_equal true
  end
  
  it "creates a book and ensures a publication and edition" do
    # this tests Edition as well as Book.  I can't think of any
    # way to mock edition that still tests useful behaviour
    
    user=User.new(:id=>-10,:name=>"dan")
    b=Book.new_with_edition(:author=>'Philip K. Dick',
                            :title=>'Time Out Of Joint',
                            :isbn=>'9780140171730',
                            :publisher=>'RoC',
                            :owner=>user)
    assert_equal 'Time Out Of Joint',b.title
    assert_equal 'Philip K. Dick',b.author
    assert_equal '9780140171730',b.isbn
    assert_equal 'RoC',b.publisher

    b2=Book.new_with_edition(:author=>'Philip K. Dick',
                             :title=>'Time Out Of Joint',
                             :isbn=>'9780110171731',
                             :publisher=>'Another publisher',
                             :owner=>user)
    refute_equal b2.edition, b.edition
    # demeter hates me
    assert_equal b2.edition.publication, b.edition.publication

    user2=User.new(:id=>-11,:name=>"fred")
    b3=Book.new_with_edition(:author=>'Philip K. Dick',
                             :title=>'Time Out Of Joint',
                             :publisher=>'RoC',
                             :isbn=>'9780140171730',
                             :owner=>user2)
    assert_equal b3.edition, b.edition
    refute_equal b3.edition, b2.edition
    assert_equal b3.edition.publication, b.edition.publication

  end
end
