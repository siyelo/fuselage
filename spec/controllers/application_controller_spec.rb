require File.dirname(__FILE__) + '/../spec_helper'
 
describe ApplicationController do
  class FooController < ApplicationController
    def index; render :text => "<html>\n\t<body>foos</body>\n</html>"; end
  end
  controller_name :foo

  before(:each) do
    ActionController::Routing::Routes.draw do |map|
      map.resources :foo
    end
  end
  
  it "should minify the HTML" do
    get :index
    response.body.should_not =~/\n/
  end  
end
