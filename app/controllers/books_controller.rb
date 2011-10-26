class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    case (p=params[:sort] and p.to_sym)
    when :where 
    then @books=Book.joins(:shelf,:collection=>:user).order("users.name,shelves.name")
    when :title
    then @books=Book.joins(:edition => :publication).order("publications.title")
    when :author
    then @books=Book.joins(:edition => :publication).order("publications.author")
    when :publisher 
    then @books=Book.joins(:edition).order("editions.publisher")
    when :isbn 
    then @books=Book.joins(:edition).order("editions.isbn")
    when :added
    then @books=Book.order(:created_at)
    else
      @books=Book.order(:created_at)
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

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @book }
    end
  end
  
  # GET /books/new
  # GET /books/new.json
  def new
    @book = Book.new(:shelf_id=>session[:shelf_id],
                     :collection_id=>session[:collection_id])
    @shelves=current_user.shelves
    @collections=current_user.collections
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @book }
    end
  end
  
  # GET /books/1/edit
  def edit
    @book = Book.find(params[:id])
    @shelves=current_user.shelves
    @collections=current_user.collections
  end
  
  # POST /books
  # POST /books.json
  def create
    @book = current_user.books.build(params[:book])
    @shelves=current_user.shelves
    @collections=current_user.collections

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
    @book.destroy

    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :ok }
    end
  end
end
