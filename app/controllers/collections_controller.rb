class CollectionsController < ApplicationController
  # GET /collections
  # GET /collections.json

  def index
    @collections = current_user.collections

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collections }
    end
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    @this = Collection.find id
    check_authorized { @this.permitted?(current_user,:show) }
    @books=@this.books.all.sort_by(&:author_sortkey)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @this }
    end
  end

  # GET /collections/new
  # GET /collections/new.json
  def new
    @collection = current_user.collections.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collection }
    end
  end

  # GET /collections/1/edit
  def edit
    @collection = Collection.find(params[:id])
    check_authorized { @collection.owner == current_user}
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = current_user.collections.build(params[:collection])
    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: 'Collection was successfully created.' }
        format.json { render json: @collection, status: :created, location: @collection }
      else
        format.html { render action: "new" }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /collections/1
  # PUT /collections/1.json
  def update
    @collection = Collection.find(params[:id])
    check_authorized { @collection.owner == current_user}
    respond_to do |format|
      if @collection.update_attributes(params[:collection])
        format.html { redirect_to @collection, notice: 'Collection was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection = Collection.find(params[:id])
    check_authorized { @collection.owner == current_user}
    @collection.destroy

    respond_to do |format|
      format.html { redirect_to collections_url }
      format.json { head :ok }
    end
  end

end
