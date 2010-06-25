# this is separate from StaticPageController since we use nested layouts
# which means the index page can have its own unique layout
class HomeController < ApplicationController
  def index
  end
end
