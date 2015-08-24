# SalesforceJob
class SalesforceJob < ActiveJob::Base
  queue_as :default

  rescue_from ActiveJob::DeserializationError do # |exception|
    # handle a deleted SalesforceReference record
  end

  def create(salesforce_reference, attributes_for_create)
    salesforce_reference.try(:local_object)
      .try(:create_new_record_in_salesforce, attributes_for_create)
  end

  def update(salesforce_reference, attributes_to_update)
    salesforce_reference.try(:local_object)
      .try(:update_record_in_salesforce, attributes_to_update)
  end

  def perform(salesforce_reference_id, attributes_for_salesforce = {},
              mode = 'update')
    logger.info '** running salesforce worker with salesforce_reference_id:' \
      " #{salesforce_reference_id} **"
    salesforce_reference = SalesforceReference.find(salesforce_reference_id)
    return false unless salesforce_reference
    if mode == 'update'
      update(salesforce_reference, attributes_for_salesforce)
    elsif mode == 'create'
      create(salesforce_reference, attributes_for_salesforce)
    end
  end
end