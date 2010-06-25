# Configure your urchin id in config/config.yml
Rubaidh::GoogleAnalytics.tracker_id = APP_CONFIG[:google][:analytics_user_id]

# For testing
# Rubaidh::GoogleAnalytics.environments = ['development', 'production']