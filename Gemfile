source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 5.2.0'

# Use Puma as the app server
gem 'puma', '~> 3.11'

# Use postgresql as the database for Active Record
gem 'pg', '0.18.1'

gem 'mysql2'

gem 'bootstrap-sass', '~> 3.4'
gem 'scss_lint', require: false

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.4'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

gem "highcharts-rails"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem "figaro"

gem 'aws-sdk', '< 2.0'
gem 'aws-sdk-s3', require: false

gem 'active_link_to', '1.0.3'
gem 'kaminari', '< 1.2.0', '>= 1.0.1'
gem 'acts-as-taggable-on', '~> 6.0'

gem 'sinatra', :require => nil

gem 'sidekiq', '5.2.7'

gem "mediaelement_rails"

gem 'httparty', require: false
gem 'rest-client', require: false # for file upload

gem 'restforce', '~> 2.3'

gem 'wistia-api'
gem 'whenever', :require => false

gem "rails-settings-cached", "~> 0.5.5"

gem 'searchkick', '~> 4.4', '>= 4.4.1'

gem 'select2-rails', '~> 3.5.0'

gem 'saml_idp', '~> 0.7.2'

gem 'roo', '1.13.2'

gem 'caxlsx'
gem 'caxlsx_rails'

gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'

gem 'exception_notification'

gem 'geocoder'

gem 'time_will_tell'

gem 'haml'

gem "material_icons", github: 'rociiu/material_icons'

gem 'zip-zip'

gem 'remotipart', '~> 1.2'

gem 'backbone-on-rails'

gem 'meta-tags'

gem 'browser', '~> 2.2'

gem 'open_uri_redirections'

gem 'sanitize'

gem "mandrill-api"

gem "validate_url"

gem "cloudfront-signer"

gem "truncate_html"

gem "flipper"
gem "flipper-redis"
gem "flipper-ui"

gem "dalli" # memcache

gem 'paperclip-compression'

gem 'sitemap_generator', require: false

gem 'dropbox_api', require: false
gem 'net-sftp', '2.1.3.rc2', require: false

gem 'trailblazer-rails'

gem 'rails_same_site_cookie', '0.1.8'

group :development do
  gem 'letter_opener'
  gem 'better_errors'
  gem "binding_of_caller"
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'rubocop-rails'
  gem 'rubocop-packaging'
  gem 'rubocop-performance'
  gem 'pry-byebug', '~> 3.9'
end

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'byebug', platform: :mri
end

group :test do
  gem 'codeclimate-test-reporter', require: nil

  gem 'database_cleaner', '~> 1.7'
  gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
  gem 'phantomjs', '~> 1.9.8'
  gem 'webmock'
  gem 'vcr', '~> 2.9.3'

  gem 'shoulda-matchers'
  gem 'capybara', '~> 2.18.0'
  gem 'selenium-webdriver'
  gem 'capybara-select-2'
  gem 'simplecov', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'spree', '~> 3.7.0'
gem 'spree_gateway', '~> 3.4'
gem 'spree_auth_devise', '~> 3.5'
gem 'spree_digital', github: 'spree-contrib/spree_digital'
gem 'spree_mail_settings', github: 'spree-contrib/spree_mail_settings'


gem 'capistrano', '~> 3.10'
gem 'capistrano-bundler', require: false
gem 'capistrano-rails', require: false
gem 'capistrano3-puma'
gem 'capistrano-rbenv', '~> 2.0'
gem 'capistrano-sidekiq'
gem 'sitemap_generator'

gem 'newrelic_rpm'

gem "hubspot-ruby"

gem 'rack', '2.2.3'

gem 'rails-controller-testing'
