# SyncSalesforceJob
class SyncSalesforceJob < ApplicationJob
  queue_as :default

  def perform(classes = nil)
    classes ||= { 'Account' => 'SchoolDistrict',
                  'Contact' => 'Spree::User',
                  'PricebookEntry' => 'Spree::Product' }
    classes.each do |name, clazz|
      import_all = (clazz == 'Spree::Product' ? true : false)
      processed = SalesforceObjectImporter.new(name, clazz.constantize).import(import_all)
      logger.info "#{processed} Salesforce #{name} records processed"
    end
  end
end
