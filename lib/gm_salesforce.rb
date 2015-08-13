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

  def find(sobject_name, id)
    client.find(sobject_name, id)
  end

  def find_all_in_salesforce(sobject_name,
                             select_columns = columns(sobject_name).join(','))
    client.query("select #{select_columns} from #{sobject_name}")
  end

  def create(salesforce_sobject_name, attributes_to_create)
    client.create(salesforce_sobject_name, attributes_to_create)
  end

  def update(salesforce_sobject_name, attributes_to_update)
    client.update(salesforce_sobject_name, attributes_to_update)
  end
end
