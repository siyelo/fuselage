# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include MinifyHTML
  include BounceBots

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :password_confirmation, :credit_card_number

  before_filter :set_default_html_meta_tags
  after_filter :minify_html

  def set_default_html_meta_tags
    @meta_description = APP_CONFIG[:meta][:description]
    @meta_keywords = APP_CONFIG[:meta][:keywords]
    @google_site_verification_key = APP_CONFIG[:google][:verification_code]
  end

  def html_meta_tags(meta_description = APP_CONFIG[:meta][:description], meta_keywords = APP_CONFIG[:meta][:keywords])
    @meta_description = "Spot.Us Community Report: " + strip_tags(meta_description)[0..180] if meta_description and !meta_description.blank?
    @meta_keywords = APP_CONFIG[:meta][:keywords] + ", " + meta_keywords if meta_keywords and !meta_keywords.blank?
  end

end
