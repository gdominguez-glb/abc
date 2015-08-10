# SalesforceJob
class SalesforceJob < ActiveJob::Base
  queue_as :default

  rescue_from ActiveJob::DeserializationError do # |exception|
    # handle a deleted user record
  end

  def create(salesforce_reference, attributes_for_create)
    sfo = salesforce_reference.try(:local_object).try(:salesforce_class)
      .try(:new, attributes_for_create)
    salesforce_reference.update_properties_from_object(sfo.save)
    attributes_for_create
  end

  def update(salesforce_reference, attributes_to_update)
    sfo = salesforce_reference.object_from_properties
    return false unless sfo
    sfo = sfo.update_attributes(attributes_to_update)
    # TODO: Handle errors from salesforce update
    salesforce_reference.local_object.try(:update_from_salesforce, sfo)
    attributes_to_update
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
