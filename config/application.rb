require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GreatMinds
  class Application < Rails::Application

    config.to_prepare do

      # load spree overrides/decorator
      ["../app/**/*_decorator*.rb", "../app/overrides/**/*.rb", ].each do |dir|
        Dir.glob(File.join(File.dirname(__FILE__), dir)) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end

      # load spree routes overrides
      File.join(File.dirname(__FILE__), "../config/spree_routes.rb").tap do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Eastern Time (US & Canada)'

    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL'
    }

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |generate|
      generate.test_framework :rspec,
          fixture:            false,
          view_specs:         false,
          routing_specs:      false,
          request_specs:      false,
          helper_specs:       false,
          integration_specs:  false

      generate.fixture_replacement :factory_girl, dir: 'spec/factories'
      generate.helper_specs false
      generate.view_specs false
    end

    initializer "spree.purchase_order.payment_methods", :after => "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Spree::PaymentMethod::PurchaseOrder
    end

    config.active_job.queue_adapter = :sidekiq
    config.action_view.sanitized_allowed_tags = ['h1', 'h2', 'h3', 'h4', 'br', 'strong', 'em', 'i', 'u', 'a', 'b', 'ul', 'li', 'ol', 'blockquote', 'strike', 'span']
  end
end
