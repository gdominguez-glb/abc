# SyncSalesforceJob
class SyncSalesforceJob < ActiveJob::Base
  queue_as :default

  def perform(classes = nil)
    classes ||= { 'Account' => 'SchoolDistrict',
                  'Contact' => 'Spree::User',
                  'PricebookEntry' => 'Spree::Product' }
    classes.each do |name, clazz|
      processed = clazz.constantize.import_salesforce.count
      logger.info "#{processed} Salesforce #{name} records processed"
    end
  end
end