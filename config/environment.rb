# Be sure to restart your server when you modify this file

#ENV['RAILS_ENV']||='production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  #config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de

  # Set DataMapper to use dm-appengine adapter
  require 'dm-core'
  DataMapper.setup(:default, "appengine://auto")

  # Set Logger from appengine-apis, all environments
  require 'appengine-apis/logger'
  config.logger = AppEngine::Logger.new

  # Skip frameworks you're not going to use.
  config.frameworks -= [ :active_record ]
end

# Enable WebDAV HTTP methods
#
WEBDAV_HTTP_METHODS = %w(propfind proppatch mkcol copy move lock unlock report)
WEBDAV_HTTP_METHODS.each do |method|
  #this will make the methods accessible for your routing
  ActionController::Routing::HTTP_METHODS << method.to_sym
end
WEBDAV_HTTP_METHOD_LOOKUP = WEBDAV_HTTP_METHODS.inject({}) { |h, m| h[m] = h[m.upcase] = m.to_sym; h }

#this adds the "new" methods to action controller

ActionController::Request::HTTP_METHODS.concat(WEBDAV_HTTP_METHODS)
ActionController::Request::HTTP_METHOD_LOOKUP.merge!(WEBDAV_HTTP_METHOD_LOOKUP)

#
