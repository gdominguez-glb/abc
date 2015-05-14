require 'databasedotcom'

class GmSalesforce

  def initialize
    @client = init_client
  end

  def init_client
    client = Databasedotcom::Client.new(
      client_id: ENV['salesforce_client_id'],
      client_secret: ENV['salesforce_client_secret']
    )
    if !Rails.env.production?
      client.host = 'test.salesforce.com'
      client.debugging = true
    end
    client.authenticate :username => ENV['salesforce_username'], :password => "#{ENV['salesforce_password']}#{ENV['salesforce_security_token']}"
    client
  end

  def list_sobjects
    @client.list_sobjects
  end

  def list_contacts
    contact_class = @client.materialize("Contact")
    contact_class.all
  end
end
