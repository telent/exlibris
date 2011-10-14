class EditionsController < ApplicationController
  # GET /editions
  # GET /editions.json
  def index
    @editions = Edition.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @editions }
    end
  end

  def isbn
    isbn=params[:id].gsub(/[^\d]/,"")
    # "not found" handling in this script is shonky at best
    raise Error unless (isbn.length >=10)
    @edition = Edition.find_by_isbn(isbn)
    if @edition then
      warn [:found,@edition]
    else
      # I am told that Rails is single-threaded.  If I'm wrong,
      # and a controller can be sent this message twice, bad things
      # may happen
      begin
        @patron||=Patron::Session.new
        @patron.base_url="https://www.googleapis.com/"
        r=@patron.get("/books/v1/volumes?q=isbn:#{isbn}")
        if (r.status==200) then
          data=JSON.parse(r.body)["items"][0]["volumeInfo"]
          p=Publication.create(title: data["title"],
                               author: data["authors"].join(", "))
          @edition=Edition.create(publisher: data["publisher"],
                                  isbn: isbn,
                                  publication: p)
        else 
          warn r.inspect
        end                                 
      rescue Error => e
        nil
      end
    end
    respond_to do |format|
      format.json { render json: {title: @edition.title, author: @edition.author, publisher: @edition.publisher, picture: @edition.picture }}
    end
  end

  # GET /editions/1
  # GET /editions/1.json
  def show
    @edition = Edition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @edition }
    end
  end

  # GET /editions/new
  # GET /editions/new.json
  def new
    @edition = Edition.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @edition }
    end
  end

  # GET /editions/1/edit
  def edit
    @edition = Edition.find(params[:id])
  end

  # POST /editions
  # POST /editions.json
  def create
    @edition = Edition.new(params[:edition])

    respond_to do |format|
      if @edition.save
        format.html { redirect_to @edition, notice: 'Edition was successfully created.' }
        format.json { render json: @edition, status: :created, location: @edition }
      else
        format.html { render action: "new" }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /editions/1
  # PUT /editions/1.json
  def update
    @edition = Edition.find(params[:id])

    respond_to do |format|
      if @edition.update_attributes(params[:edition])
        format.html { redirect_to @edition, notice: 'Edition was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @edition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /editions/1
  # DELETE /editions/1.json
  def destroy
    @edition = Edition.find(params[:id])
    @edition.destroy

    respond_to do |format|
      format.html { redirect_to editions_url }
      format.json { head :ok }
    end
  end
end
