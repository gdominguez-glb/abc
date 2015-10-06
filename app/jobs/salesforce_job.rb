# SalesforceJob
class SalesforceJob < ActiveJob::Base
  queue_as :default

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
    if mode == 'update' && salesforce_reference.id_in_salesforce.present?
      update(salesforce_reference, attributes_for_salesforce)
    elsif mode == 'create' ||
          (mode == 'update' && salesforce_reference.id_in_salesforce.blank?)
      create(salesforce_reference, attributes_for_salesforce)
    end
  end
end
