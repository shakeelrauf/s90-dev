require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module S92Dev
  class Application < Rails::Application
  	config.assets.paths << Rails.root.join("app", "assets", "fonts")
  	config.assets.paths << Rails.root.join("app", "assets", "flags")
  	config.assets.paths << Rails.root.join("app", "assets", "sounds")
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_record.time_zone_aware_types = [:datetime, :time]
    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => :any
      end
    end

    config.generators do |g|
		  g.orm :active_record
		end
  end
end
