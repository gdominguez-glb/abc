Spree::AppConfiguration.class_eval do
  preference :mails_from, :string

  preference :salesforce_production, :boolean, default: false
  preference :salesforce_client_id, :string
  preference :salesforce_client_secret, :string
  preference :salesforce_enabled, :boolean, default: true

  preference :salesforce_username, :string
  preference :salesforce_password, :string
  preference :salesforce_security_token, :string
end
