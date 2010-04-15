class HomeController < ApplicationController
  PAGES = %w[about] #allowable (non-index) pages rendered by show action

  def index
  end

  #
  def show
    render :action => params[:page]
  end

end
