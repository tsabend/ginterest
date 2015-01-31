class SessionsController < ApplicationController

  def create
    auth = env['omniauth.auth']
    if user = User.where(email: auth["info"]["email"]).first
      session[:user_id] = user.id
      user.get_all_commits.each do |commit_array|
        if commit_array
          commit_array.each do |commit|
            Commit.from_algorithm(commit)
         end
       end
      end
      redirect_to root_url, :notice => "Welcome back #{user.username}"
    else
      user = User.create_with_omniauth(auth)
      session[:user_id] = user.id
      user.get_all_commits.each do |commit_array|
        commit_array.each do |commit|
          Commit.from_algorithm(commit)
        end
      end
      redirect_to root_url, :notice => "Welcome #{user.username}"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Peace"
  end
end
