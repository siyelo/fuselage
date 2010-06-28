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
  
  context "minify HTML" do
    it "should minify the HTML" do
      get :index
      response.body.should_not =~/\n/
    end  
  end
  
  context "meta tags" do
    it "should have  set_default_html_meta_tags as a before filter" do  
      ApplicationController.before_filters.should include(:set_default_html_meta_tags)
    end
    
    it "should insert meta tags" do
      APP_CONFIG[:meta][:description] = "some description"
      APP_CONFIG[:meta][:keywords] = "some keywords"
      get :index
      assigns[:meta_description].should  == "some description"
      assigns[:meta_keywords].should == "some keywords"
    end
  end
end
