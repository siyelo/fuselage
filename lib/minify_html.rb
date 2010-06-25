module MinifyHTML
  # minify the html
  def minify_html
    unless Rails.env.development?
      response.body.gsub!(/[ \t\v]+/, ' ')
      response.body.gsub!(/\s*[\n\r]+\s*/, "\n")
      response.body.gsub!(/>\s+</, '> <')
      response.body.gsub!(/<\!\-\-([^>\n\r]*?)\-\->/, '')
    end
  end

end