require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scrappy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.api_only = false

    RailsTemplateCache.setup do |config|
	  config.templates_path = File.join( ['app', 'assets', 'javascripts'] )
	  config.extensions = %w(erb haml html slim)
	  config.compress_html = false
	  config.prepend_client_path = ''
	end 

  end
end
