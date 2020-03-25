# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( styleguide.css )
Rails.application.config.assets.precompile += %w( styleguide-extras.css )
Rails.application.config.assets.precompile += %w( frontend.js )
Rails.application.config.assets.precompile += %w( account.js )
Rails.application.config.assets.precompile += %w( cms.js )
Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/
