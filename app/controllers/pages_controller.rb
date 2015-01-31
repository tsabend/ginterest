class PagesController < ApplicationController

  def index
    @user = current_user
    @cohorts = Cohort.all
  end
end
