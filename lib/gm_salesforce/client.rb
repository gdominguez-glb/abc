module GmSalesforce
  # Client
  class Client
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
        Restforce.log = !Rails.env.test?
      end

      Restforce.new sf_params
    end

    def self.date_to_salesforce(date)
      return nil if date.blank?
      date.as_json.gsub(/Z\Z/, '+0000')
    end

    def columns(sobject_name)
      capture_net_errors { client.describe(sobject_name).fields.map(&:name) }
    end

    def find(sobject_name, id)
      capture_net_errors { client.find(sobject_name, id) }
    end

    def find_all_in_salesforce(sobject_name,
                               select_columns = columns(sobject_name).join(','),
                               where = nil)
      capture_net_errors do
        query_str = "select #{select_columns} from #{sobject_name}"
        query_str += " where #{where}" if where.present?
        client.query(query_str)
      end
    end

    def create(salesforce_sobject_name, attributes_to_create)
      capture_net_errors { client.create!(salesforce_sobject_name, attributes_to_create) }
    end

    # `attributes_to_update` should include `Id`
    def update(salesforce_sobject_name, attributes_to_update)
      capture_net_errors { client.update!(salesforce_sobject_name, attributes_to_update) }
    end

    def capture_net_errors(&block)
      block.call
    rescue Faraday::ConnectionFailed, Faraday::Error::ClientError,
           Faraday::ResourceNotFound, Faraday::ClientError => e
      raise GmSalesforce::Error.generate(e)
    end
  end
end
