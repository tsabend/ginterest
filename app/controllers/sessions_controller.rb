class SessionsController < ApplicationController

  def create
    auth = env['omniauth.auth']
    if user = User.where(email: auth["info"]["email"]).first
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Welcome back #{user.username}"
    else
      user = User.create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Welcome #{user.username}"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Peace"
  end

end
