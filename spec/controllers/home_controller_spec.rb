require File.dirname(__FILE__) + '/../spec_helper'
 
describe HomeController do
  integrate_views

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "should show a favicon" do
    pending
    lambda { get '/images/favico.ico' }.should_not raise_error ActionController::RoutingError
  end
  
end
