class NewsController < ApplicationController
  def show
    if current_user then
      # render
    else
      redirect_to url_for(:action=>'new',:controller=>'sessions')
    end
  end
end
