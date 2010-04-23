class HomeController < ApplicationController
  PAGES = %w[about] #allowable (non-index) pages rendered by show action

  def index
    render :layout => 'landing_page'
  end

  #
  def show
    render :action => params[:page], :layout => 'inner_page'
  end

end
