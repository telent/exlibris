class Edition < ActiveRecord::Base
  belongs_to :publication
  def title;    self.publication.title ;  end
  def author;    self.publication.author ;  end

  def self.find_or_create_by_isbn(isbn)
    isbn=isbn.gsub(/[^\d]/,"")
    if isbn.length < 10 then raise Error, "Invalid ISBN format" end
    e=self.find_by_isbn(isbn)
    if e.nil? then
      patron=Patron::Session.new
      patron.base_url="https://www.googleapis.com/"
      r=patron.get("/books/v1/volumes?q=isbn:#{isbn}")
      if (r.status==200) then
        data=JSON.parse(r.body)["items"][0]["volumeInfo"]
        p=Publication.create(title: data["title"],
                             author: data["authors"].join(", "))
        e=Edition.create(publisher: data["publisher"],
                         isbn: isbn,
                         publication: p)
      else 
        raise Error,"ISBN lookup failed: #{r.status}"
      end                                 
    end
    e
  end
end
