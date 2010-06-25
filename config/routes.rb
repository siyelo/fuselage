ActionController::Routing::Routes.draw do |map|
  map.static_page ':page',
    :controller => 'static_page',
    :action => 'show',
    :page => Regexp.new(%w[about contact].join('|'))

  map.root :controller => 'home', :action => 'index' # a replacement for public/index.html, with unique layout
end
