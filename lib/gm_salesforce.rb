# GmSalesforce
class GmSalesforce
  include Singleton

  attr_reader :client

  def initialize
    @client = init_client
  end

  def salesforce_params
    {
      username: ENV['salesforce_username'],
      password: ENV['salesforce_password'],
      security_token: ENV['salesforce_security_token'],
      client_id: ENV['salesforce_client_id'],
      client_secret: ENV['salesforce_client_secret'],
      api_version: '32.0'
    }
  end

  def init_client
    sf_params = salesforce_params
    unless Rails.env.production?
      sf_params[:host] = 'test.salesforce.com'
      Restforce.log = true
    end

    Restforce.new sf_params
  end

  def columns(sobject_name)
    client.describe(sobject_name).fields.map(&:name)
  end
end
