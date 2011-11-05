class ShelvesController < ApplicationController
  # GET /shelves
  # GET /shelves.json
  def index
    @shelves = current_user.shelves.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shelves }
    end
  end

  # GET /shelves/1
  # GET /shelves/1.json
  def show
    @shelf = Shelf.find(params[:id])
    check_authorized { @shelf.owner == current_user }
    @books = @shelf.books.sort_by(&:author_sortkey)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shelf }
    end
  end

  # GET /shelves/new
  # GET /shelves/new.json
  def new
    @shelf = Shelf.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shelf }
    end
  end

  # GET /shelves/1/edit
  def edit
    @shelf = Shelf.find(params[:id])
    check_authorized { @shelf.owner == current_user }
  end

  # POST /shelves
  # POST /shelves.json
  def create
    @shelf = current_user.shelves.build(params[:shelf])

    respond_to do |format|
      if @shelf.save
        format.html { redirect_to current_user, notice: 'Shelf was successfully created.' }
        format.json { render json: @shelf, status: :created, location: @shelf }
      else
        format.html { render action: "new" }
        format.json { render json: @shelf.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shelves/1
  # PUT /shelves/1.json
  def update
    @shelf = Shelf.find(params[:id])

    respond_to do |format|
      if @shelf.update_attributes(params[:shelf])
        format.html { redirect_to @shelf, notice: 'Shelf was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @shelf.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shelves/1
  # DELETE /shelves/1.json
  def destroy
    @shelf = Shelf.find(params[:id])
    check_authorized { @shelf.owner == current_user }
    @shelf.destroy

    respond_to do |format|
      format.html { redirect_to shelves_url }
      format.json { head :ok }
    end
  end
end
