require 'gm_salesforce'

# SalesforceAccess
module SalesforceAccess
  extend ActiveSupport::Concern

  included do
    has_one :salesforce_reference, as: :local_object, dependent: :destroy
    accepts_nested_attributes_for :salesforce_reference, update_only: true
    attr_accessor :skip_next_salesforce_update
    attr_accessor :skip_salesforce_create
    after_update :update_salesforce
    after_create :create_in_salesforce
  end

  def salesforce_sobject_name
    self.class.sobject_name
  end

  def cached_salesforce_object
    salesforce_reference.try(:object_from_properties)
  end

  def id_in_salesforce
    salesforce_reference.try(:id_in_salesforce)
  end

  def find_in_salesforce_by_salesforce_id(sid = id_in_salesforce)
    return nil unless sid
    salesforce_api.client.find(salesforce_sobject_name, sid)
  end

  # this follows our convention where we store our pk in salesforce's MemberID
  def find_in_salesforce_by_member_id(mid = id)
    return nil unless mid
    salesforce_api.client.find(salesforce_sobject_name, sid, 'MemberID__c')
  end

  # override this to do the default search for a unique record (if not by ID)
  # E.g.: `salesforce_class.find_by_Email(email)` or
  # `find_in_salesforce_by_member_id`
  def find_in_salesforce
    find_in_salesforce_by_salesforce_id
  end

  # override this as necessary
  def update_from_salesforce(sfo = find_in_salesforce)
    # TODO: Check verified?  `@Verified__c`
    # TODO: Check deleted? `@IsDeleted`
    return false unless sfo
    incoming_attributes = self.class.attributes_from_salesforce_object(sfo)
    if cached_salesforce_object
      cached_attributes = self.class.attributes_from_salesforce_object(
        cached_salesforce_object).except(:salesforce_reference_attributes,
                                         :skip_next_salesforce_update)
      compare_attributes = incoming_attributes
        .except(:salesforce_reference_attributes, :skip_next_salesforce_update)
      return self if cached_attributes == compare_attributes
    end
    update_attributes(incoming_attributes)
  end

  def changed_since_salesforce?
    return true if !salesforce_reference || !salesforce_reference
      .last_imported_from_salesforce_at
    updated_at > salesforce_reference.last_imported_from_salesforce_at
  end

  # Override this with attributes to update in Salesforce
  # in the format {salesforceAttribute: 'value'}
  def attributes_for_salesforce
    {}
  end

  def changed_attributes_for_salesforce(sfo = cached_salesforce_object)
    matching_attributes = attributes_for_salesforce
    changed_keys = matching_attributes.keys.select do |key|
      sfo.send(key) != matching_attributes[key]
    end
    matching_attributes.slice(*changed_keys)
  end

  # Checks whether there is a corresponding (cached) record from Salesforce
  def should_update_salesforce?
    if skip_next_salesforce_update
      self.skip_next_salesforce_update = nil
      return false
    end
    return false unless cached_salesforce_object
    changed_since_salesforce?
  end

  # Only updates if there is a corresponding cached record from Salesforce
  def update_salesforce(fields = nil)
    return {} unless should_update_salesforce?
    # TODO: Handle both modified case
    sfo = cached_salesforce_object
    # TODO: Handle case where sfo is nil
    attributes_to_update = changed_attributes_for_salesforce(sfo)
    attributes_to_update.slice! fields if fields.present?
    return {} if attributes_to_update.blank?
    SalesforceJob.perform_later(salesforce_reference.id,
                                attributes_to_update)
    attributes_to_update
  end

  # override to customize attributes for create
  def new_attributes_for_salesforce
    attributes_for_salesforce # .merge 'OwnerId' => self.class.salesforce_user_id
  end

  def should_create_salesforce?
    !skip_salesforce_create
  end

  def create_in_salesforce(fields = nil)
    return {} unless should_create_salesforce?
    # TODO: Handle both modified case
    attributes_to_create = new_attributes_for_salesforce
    attributes_to_create.slice! fields if fields.present?
    return {} if attributes_to_create.blank?
    ref = salesforce_reference || create_salesforce_reference
    SalesforceJob.perform_later(ref.id, attributes_to_create, 'create')
    attributes_to_create
  end

  class_methods do
    # Override this to set the object name in Salesforce (e.g. 'Contact')
    def sobject_name
      name
    end

    # Override this as necessary, for example how to match fields other than ID
    def matches_salesforce_object(sfo)
      return none if sfo.blank?
      joins(:salesforce_reference).where(
        'salesforce_references.id_in_salesforce' => sfo.Id)
    end

    def find_in_salesforce_by_salesforce_id(id)
      salesforce_api.client.find(sobject_name, id)
    end

    def salesforce_api
      @gm_salesforce ||= GmSalesforce.instance
    end

    def find_all_in_salesforce
      salesforce_api.client.query(
        "select #{salesforce_api.columns(sobject_name).join(',')} " \
        "from #{sobject_name}")
    end

    def salesforce_reference_attributes(sfo)
      {
        id_in_salesforce: sfo.Id,
        last_modified_in_salesforce_at: sfo.LastModifiedDate,
        last_imported_from_salesforce_at: Time.zone.now,
        object_properties: sfo.to_hash
      }
    end

    # override this as necessary adding in attributes to set
    def attributes_from_salesforce_object(sfo)
      {
        skip_next_salesforce_update: true,
        skip_salesforce_create: true,
        salesforce_reference_attributes: salesforce_reference_attributes(sfo)
      }
    end

    # override this as necessary, including to prevent creation on match
    def find_or_create_by_salesforce_object(sfo, &block)
      return nil if sfo.blank?
      matches_salesforce_object(sfo).first_or_create(
        attributes_from_salesforce_object(sfo), &block)
    end

    # override this to delete records
    # E.g.: `where.not(id: updated_records.map(&:id)).destroy_all`
    def remove_deleted_records(updated_records)
      return nil if updated_records.blank?
      []
    end

    def create_or_update_record(sfo)
      new_record = false
      local_object = find_or_create_by_salesforce_object(sfo) do
        new_record = true
      end
      local_object.update_from_salesforce(sfo) if local_object && !new_record
      local_object
    end

    def create_or_update_records(salesforce_objects)
      return nil if salesforce_objects.blank?
      updated_records = []
      salesforce_objects.each do |sfo|
        updated_records << create_or_update_record(sfo)
      end
      updated_records
    end

    def import_salesforce
      salesforce_objects = find_all_in_salesforce
      updated_records = create_or_update_records(salesforce_objects)
      remove_deleted_records(updated_records)

      salesforce_objects
    end
  end
end
