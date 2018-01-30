source 'https://rubygems.org'

ruby '2.1.6'

gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'

gem 'mysql2'

gem 'bootstrap-sass', '~> 3.3.6'
gem 'scss_lint', require: false

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.4'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem "highcharts-rails"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem "figaro"

gem 'aws-sdk', '< 2.0'
gem 'aws-sdk-s3', require: false

gem 'active_link_to'
gem 'kaminari'
gem 'acts-as-taggable-on', '~> 3.4'

gem 'sinatra', :require => nil

gem 'sidekiq'

gem "mediaelement_rails"

gem 'httparty', require: false
gem 'rest-client', require: false # for file upload

gem 'restforce', '~> 2.3'

gem 'wistia-api'
gem 'whenever', :require => false

gem "rails-settings-cached", "0.4.1"

gem 'searchkick'

gem 'select2-rails'

gem 'doorkeeper'

gem 'roo', '1.13.2'

gem 'axlsx_rails', '~> 0.4'

gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'

gem 'exception_notification'

gem 'geocoder'

gem 'time_will_tell'

gem 'haml'
gem 'nkss-rails', github: 'nadarei/nkss-rails'

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

gem 'trumbowyg_rails'

gem 'paperclip-compression'

gem 'sitemap_generator', require: false

gem 'dropbox_api', require: false

group :development do
  gem 'quiet_assets'
  gem 'letter_opener'
  gem 'better_errors'
  gem "binding_of_caller"
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'web-console', '~> 2.3.0'
end

group :development, :test do
  gem 'pry'
  gem 'rspec-rails', '~> 3.2.1'
end

group :test do
  gem 'codeclimate-test-reporter', require: nil

  gem 'database_cleaner', '~> 1.4.1'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'phantomjs', '~> 1.9.8'
  gem 'webmock'
  gem 'vcr', '~> 2.9.3'

  gem 'shoulda-matchers'
  gem 'test_after_commit'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'spree', '3.0.0'
gem 'spree_gateway', github: 'spree/spree_gateway', branch: '3-0-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-0-stable'
gem 'spree_digital', github: 'rociiu/spree_digital', branch: '3-0-stable'
gem 'spree_mail_settings', github: 'spree-contrib/spree_mail_settings', branch: '3-0-stable'
gem 'spree_better_terms_and_conditions', github: 'aleks/spree_better_terms_and_conditions'

# chef gems
group :development do
  gem 'knife-solo', '~> 0.4.2'
end

gem 'capistrano', '~> 3.4.0'
gem 'capistrano-rbenv', '~> 2.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'

gem 'unicorn', '~> 4.8.3'

gem 'newrelic_rpm'

gem "hubspot-ruby"

