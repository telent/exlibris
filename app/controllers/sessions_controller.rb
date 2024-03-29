class SessionsController < ApplicationController
  def new
  end
  def create
    auth=request.env['omniauth.auth']
    a=Authorization.find_or_create_by_provider_and_uid(auth["provider"],auth["uid"])
    u=a.user
    if u then
      session[:user_id]=u.id
      redirect_to "/"
    else
      i=auth["user_info"]
      u=User.create :authorizations=>[a],
      :name=>(i["nickname"] || (i["name"].downcase.gsub(/[^a-zA-Z0-9]/,"_"))),
      :image=>i["image"],
      :fullname=>i["name"]
      session[:user_id]=u.id
      redirect_to edit_user_path(u)
    end
  end
  def destroy
    session.delete(:user_id)
  end
end
