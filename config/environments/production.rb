# encoding: utf-8
TorSearch::Application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb
  config.eager_load = true
  config.mixpanel_token = '6124654cc7832f80568bacca42e807ea'

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  if config.redis.blank?
    config.cache_store = :file_store, "/var/rails/tor_search/tmp/cache"
  else
    config.cache_store = :redis_store, config.redis
  end

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and
  # use secure cookies.
  # config.force_ssl = true

  config.action_mailer.default_url_options = { :host => 'torsearch.es' }

  config.action_mailer.raise_delivery_errors = false
  
  # ActionMailer::Base.smtp_settings = {
  #   :address => "smtp.sendgrid.net",
  #   :port => 587,
  #   :domain => "torsearch.es",
  #   :authentication => :plain,
  #   :user_name => 'torsearch_mail',
  #   :password => 'jDFkTzo9Tk4N7f^THy%4&eDr2sboVjO#19MgakUDx*Xx#3LG!Z'
  # }

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
  config.logger = Syslogger.new("tor-search", Syslog::LOG_PID, Syslog::LOG_LOCAL0)
  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css,
    # and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
