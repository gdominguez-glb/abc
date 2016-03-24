module Spree
  module Admin
    class SalesforceTokensController < BaseController
      def update
        params.each do |name, value|
          next unless Spree::Config.has_preference? name
          Spree::Config[name] = value
        end
        Singleton.__init__(GmSalesforce::Client)
        flash[:success] = "Updated salesforce token successfully."
        redirect_to edit_admin_salesforce_token_url
      end

      def test_token
        GmSalesforce::Client.instance.columns('Account')
        flash[:success] = 'Salesforce token works fine.'
      rescue => e
        flash[:error] = "Salesforce token not work: #{e}"
      ensure
        redirect_to edit_admin_salesforce_token_url
      end
    end
  end
end
