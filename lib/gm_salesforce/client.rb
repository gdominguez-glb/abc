module GmSalesforce
  # Client
  class Client

    attr_reader :client

    def self.instance
      GmSalesforce::Client.new
    end

    def initialize
      @client = init_client
    end

    def salesforce_params
      {
        username: Spree::Config[:salesforce_username],
        password: Spree::Config[:salesforce_password],
        security_token: Spree::Config[:salesforce_security_token],
        client_id: Spree::Config[:salesforce_client_id],
        client_secret: Spree::Config[:salesforce_client_secret],
        api_version: '38.0'
      }
    end

    def init_client
      sf_params = salesforce_params
      if !Spree::Config[:salesforce_production]
        sf_params[:host] = 'test.salesforce.com'
        Restforce.log = !!ENV['RESTFORCE_LOG']
      end

      Restforce.new sf_params
    end

    def column_info(sobject_name, column_name)
      capture_net_errors { client.describe(sobject_name).fields.find{|field| field.name == column_name || field.label == column_name } }
    end

    def query(q)
      capture_net_errors { client.query(q) }
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
        query_str = construct_basic_query(sobject_name, select_columns, where)
        client.query(query_str)
      end
    end

    def find_all_in_salesforce_by_pagination(sobject_name,
                               select_columns = columns(sobject_name).join(','),
                               where = nil, per_page = 100, &block)
      capture_net_errors do
        query_str = construct_basic_query(sobject_name, select_columns, where)
        execute_pagination_loop_query(query_str, per_page, &block)
      end
    end

    def execute_pagination_loop_query(base_query, per_page, &block)
      last_sf_id = nil
      while true do
        page_query = append_order_phase_to_query(base_query, last_sf_id, per_page)
        result = client.query(page_query)
        block.call(result)
        break if result.count < per_page
        last_sf_id = result.entries.last.Id
      end
    end

    def construct_basic_query(sobject_name, select_columns, where)
      query_str = "select #{select_columns} from #{sobject_name}"
      query_str += " where #{where}" if where.present?
      query_str
    end

    def append_order_phase_to_query(query, last_sf_id, per_page)
      page_query = query
      if last_sf_id
        if !query.include?('where')
          page_query += " where Id < '#{last_sf_id}' "
        else
          page_query += " and Id < '#{last_sf_id}' "
        end
      end
      page_query + " order by Id desc limit #{per_page}"
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
