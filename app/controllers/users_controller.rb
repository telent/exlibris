class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    @users = User.paginate page: params[:page], per_page: 20

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def me
    redirect_to current_user
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @collections=@user.collections.select {|c| 
      c.permitted?(current_user,:show)
    }
    @shelves=(@user==current_user) && @user.shelves
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def friends
    # XXX when we implement borrow requests, this request should return
    # users with borrow requests first, and other followers afterward
    @friends=current_user.followers
    render "friends",  layout: nil
  end
  
  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  protected
  def check_rights
    if id=params[:id] then
      @user = User.find id
    else
      @user=User
    end
    warn [:action,action_name,:user,@user,:current,current_user]
    if !@user.permitted?(current_user,action_name) then
      render :text=>"Unauthorized", :status=>401
    end
  end
end
