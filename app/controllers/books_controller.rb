class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books=current_user.books
    case (p=params[:sort] and p.to_sym)
    when :where 
    then @books=@books.joins(:shelf,:collection=>:user).order("users.name,shelves.name")
    when :title
    then @books=@books.joins(:edition => :publication).order("publications.title")
    when :author
    then @books=@books.joins(:edition => :publication).order("publications.author")
    when :publisher 
    then @books=@books.joins(:edition).order("editions.publisher")
    when :isbn 
    then @books=@books.joins(:edition).order("editions.isbn")
    when :added
    then @books=@books.order(:created_at)
    else
      @books=@books.order(:created_at)
    end
    if params[:direction]=='d' then
      @books=@books.reverse_order
    end
    @books=@books.paginate page: params[:page], per_page: 20
    @shelves=current_user.shelves.sort_by(&:name)
    @collections=current_user.collections.sort_by(&:name)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @books }
    end
  end

  def organize
    books=Book.where(:id=> params[:check].map(&:to_i))
    if s=params[:reshelve][:shelf_id] and s.present? and 
        shelf=Shelf.find(s.to_i) and
        shelf.owner == current_user
      books.update_all :shelf_id=>shelf.id
    end
    if c=params[:collection][:collection_id] and c.present? and
        collection=Collection.find(c.to_i) and
        collection.owner == current_user
      books.update_all :collection_id=>collection.id
    end
      
    redirect_to :action => :index
  end 

  def lend
    book=Book.find(params[:id])
    check_authorized { book.owner == current_user }
    book.lend(User.find(params[:borrower_id]))
    redirect_to :action=>:show
  end

  def return
    book=Book.find(params[:id])
    check_authorized { book.owner == current_user }
    book.return
    redirect_to :action=>:show
  end


  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    check_authorized { @book.collection.permitted?(current_user,:show) }
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end
  
  # GET /books/new
  # GET /books/new.json
  def new
    # we don't need to go wild checking permissions here as all this
    # does is display a form
    @shelves=current_user.shelves
    @collections=current_user.collections
    @book = Book.new(:shelf_id=>session[:shelf_id],
                     :isbn=>params[:isbn],
                     :collection_id=>session[:collection_id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end
  
  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
    check_authorized { @book.owner == current_user }
    @shelves=current_user.shelves
    @collections=current_user.collections
  end
  
  # POST /books
  # POST /books.json
  def create
    @book = current_user.books.build(params[:book])
    @shelves=current_user.shelves
    @collections=current_user.collections
    check_authorized { 
      # make sure we're adding to our own shelf/collection
      @shelves.map(&:id).member?(params[:book][:shelf_id]) &&
      @collections.map(&:id).member?(params[:book][:collection_id])
    }
    session[:shelf_id]=params[:book][:shelf_id]
    session[:collection_id]=params[:book][:collection_id]
    respond_to do |format|
      if @book.save
        format.html { redirect_to new_book_path, notice: 'Book "#{book.title}" was successfully added.' }
        format.json { render json: @book, status: :created, location: @book }
      else
        format.html { render action: "new" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /books/1
  # PUT /books/1.json
  def update
    @book = Book.find(params[:id])
    check_authorized { 
      @book.owner == current_user
    }

    respond_to do |format|
      if @book.update_attributes(params[:book])
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book = Book.find(params[:id])
    check_authorized { 
      @book.owner == current_user
    }
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :ok }
    end
  end
end
