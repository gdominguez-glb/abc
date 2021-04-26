module Spree
  module Admin
    # SalesforceController
    class SalesforceController < Spree::Admin::BaseController
      def sync
        SyncSalesforceJob.perform_later

        respond_to do |format|
          format.js { render body: nil }
        end
      end
    end
  end
end
