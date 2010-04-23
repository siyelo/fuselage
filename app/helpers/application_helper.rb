module ApplicationHelper

  # Usage: simply invoke title() at the top of each view
  # E.g.
  # - title "Home"
  def title(page_title)
    content_for(:title) { page_title }
  end

  #http://m.onkey.org/2009/7/7/nested-layouts
  def parent_layout(layout)
    @content_for_layout = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
 end

end
