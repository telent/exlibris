class SessionsController < ApplicationController
  def create
    auth=request.env['omniauth.auth']
    #warn [:auth,auth]
    a=Authorization.find_or_create_by_provider_and_uid(auth["provider"],auth["uid"])
    u=a.user
    if u then
      session[:user_id]=u.id
      redirect_to "/"
    else
      i=auth["user_info"]
      u=User.create :authorizations=>[a],
      :name=>(i["nickname"] || (i["name"].downcase.gsub(/[^a-zA-Z0-9]/,"_"))),
      :fullname=>i["name"]
      session[:user_id]=u.id
      redirect_to edit_user_path(u)
    end
  end
end
