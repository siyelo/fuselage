file 'app/helpers/application_helper.rb', 
%q{module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"
  end
  
  # Usage: simply invoke title() at the top of each view
  # E.g. 
  # - title "Home"
  def title(page_title)
    content_for(:title) { page_title }
  end
  
end
}

  
file 'app/views/layouts/_flashes.html.haml', 
%q{#flash
  - flash.each do |key, value|
    #flash{:id => key.to_s}
      = h value
}

# A haml + blueprint compatible layout
file 'app/views/layouts/application.html.haml', <<-EOS
!!! XML
!!! Strict
%html
  %head
    - page_title = yield(:title) || APP_DESCRIPTION
    %title= APP_NAME + " | " + page_title
    
    = stylesheet_link_tag 'compiled/screen.css', :media => 'screen, projection'
    = stylesheet_link_tag 'compiled/print.css', :media => 'print'
    /[if IE]
      = stylesheet_link_tag 'compiled/ie.css', :media => 'screen, projection'
    
  %body.three-col
    #container
      #header
        %h2 Header
      #content
        %h2 Content
        = render :partial => 'layouts/flashes'
        = yield :layout
      #sidebar
        %h2 Sidebar
      #footer
        %h2 Footer
  
EOS