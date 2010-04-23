class StaticPageController < ApplicationController
  PAGES = %w[about] #allowable (non-index) pages rendered by show action

  def show
    render :action => params[:page]
  end

end
