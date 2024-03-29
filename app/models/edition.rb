class Edition < ActiveRecord::Base
  belongs_to :publication
  validates_associated :publication
  def title;    p=self.publication and p.title ;  end
  def author;    p=self.publication and p.author ;  end
  def author_sortkey;    p=self.publication and p.author_sortkey ;  end

  validate :publication_exists
  def publication_exists 
    unless (self.publication || self.publication_id.present?) then
      errors.add(:publication, "publication missing")
    end
  end

  def initialize(a={})
    if (a[:author].present? || a[:title].present? )
      p=Publication.find_or_initialize_by_author_and_title(a[:author],a[:title])
      a[:publication]=p
    end
    a.delete :author
    a.delete :title
    a.delete :blurb
    super(a)
  end

  def self.google_lookup_isbn(isbn)
    isbn=isbn.gsub(/[^\d]/,"")
    patron=Patron::Session.new
    patron.base_url="https://www.googleapis.com/"
    r=patron.get("/books/v1/volumes?q=isbn:#{isbn}")
    if (r.status==200) then
      data=JSON.parse(r.body)
      if(data["totalItems"].to_i > 0) then
        v=data["items"][0]["volumeInfo"]
        self.new(publisher: v["publisher"],
                 title: v["title"],
                 author: v["authors"].join(", "),
                 isbn: isbn,
                 publication: p)
      end
    end
  end

  before_save :save_publication
  
  private
  def save_publication
    p=self.publication and p.save
  end
end
