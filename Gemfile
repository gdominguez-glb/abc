source 'https://rubygems.org'


gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'

gem 'bootstrap-sass', '~> 3.3.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

gem "figaro"

gem 'zeroclipboard-rails'

gem 'aws-sdk', '< 2.0'

gem 'active_link_to'
gem 'kaminari'
gem 'acts-as-taggable-on', '~> 3.4'
gem 'sidekiq'

group :development do
  gem 'pry'
  gem 'spring'
  gem 'quiet_assets'
  gem 'letter_opener'
  gem 'better_errors'
  gem "binding_of_caller"
end

group :development, :test do
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
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'spree', '3.0.0'
gem 'spree_gateway', github: 'spree/spree_gateway', branch: '3-0-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-0-stable'
gem 'spree_digital', github: 'spree-contrib/spree_digital', branch: '3-0-stable'
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

gem 'unicorn', '~> 4.8.3'
