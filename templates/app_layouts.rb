file 'app/helpers/application_helper.rb', 
%q{module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
  
  def title(page_title)
    content_for(:title) { page_title }
  end
  
end
}

  
file 'app/views/layouts/_flashes.html.haml', 
%q{#flash
  - flash.each do |key, value|
    #flash{:id => key}
      = h value
}

file 'app/views/layouts/application.html.haml', <<-EOS
!!! XML
!!! Strict
%html
  %head
    - title = yield(:title)
    - title = "APP_NAME | " + title if title
    %title= title || \'APP_DESCRIPTION\'
    
    = stylesheet_link_tag 'compiled/screen.css', :media => 'screen, projection'
    = stylesheet_link_tag 'compiled/print.css', :media => 'print'
    /[if IE]
      = stylesheet_link_tag 'compiled/ie.css', :media => 'screen, projection'
    
  %body
    #content
      - render :partial => 'layouts/flashes'
      = yield :layout
  
EOS