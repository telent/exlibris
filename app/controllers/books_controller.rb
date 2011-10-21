class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @books = current_user.books.sort_by(&:author_sortkey)
    
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
    @book = Book.new
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
