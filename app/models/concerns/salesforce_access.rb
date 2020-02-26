require 'gm_salesforce'

# SalesforceAccess
module SalesforceAccess
  extend ActiveSupport::Concern

  included do
    has_one :salesforce_reference, as: :local_object, dependent: :destroy
    accepts_nested_attributes_for :salesforce_reference, update_only: true
    attr_accessor :skip_next_salesforce_update
    attr_accessor :skip_salesforce_create
    after_commit :update_salesforce, on: :update, if: :persisted?
    after_commit :create_in_salesforce, on: :create, if: :persisted?
  end

  # Gets the Salesforce object name for this instance
  def salesforce_sobject_name
    self.class.sobject_name
  end

  # Gets the Salesforce object from the cached properties
  def cached_salesforce_object
    salesforce_reference.try(:object_from_properties)
  end

  # Gets the corresponding Salesforce Id for this instance
  def id_in_salesforce
    salesforce_reference.try(:id_in_salesforce)
  end

  # Queries the SObject in Salesforce corresponding to this instance by Id
  def find_in_salesforce_by_salesforce_id(sid = id_in_salesforce)
    return nil unless sid
    self.class.find_in_salesforce_by_salesforce_id(sid)
  end

  # Add method to skip to custom skip on salesforce sync
  def skip_salesforce_sync?
    false
  end

  # Override this method to run when salesforce object is updated
  def update_from_cached_salesforce_object
  end

  # this follows our convention where we store our pk in salesforce's MemberID
  # def find_in_salesforce_by_member_id(mid = id)
  #   return nil unless mid
  #   salesforce_api.client.find(salesforce_sobject_name, sid, 'MemberID__c')
  # end

  # Finds a corresponding Salesforce object to this instance by default match
  #
  # Override this to do the default search for a unique record (if not by ID)
  def find_in_salesforce
    find_in_salesforce_by_salesforce_id
  end

  # Updates the local record based on the salesforce object.  Note that this
  # does not update the associated `salesforce_reference` object
  def reset_from_salesforce(sfo = cached_salesforce_object)
    return nil unless sfo
    incoming_attributes = self.class.attributes_from_salesforce_object(sfo)
    incoming_attributes.delete(:salesforce_reference_attributes)
    update_attributes(incoming_attributes)
    save
  end

  def incoming_changes?(incoming_attributes)
    ignore_attributes = [:salesforce_reference_attributes,
                         :skip_next_salesforce_update,
                         :skip_salesforce_create]

    cached_attributes = self.class.attributes_from_salesforce_object(
      cached_salesforce_object).except(*ignore_attributes)
    compare_attributes = incoming_attributes.except(*ignore_attributes)

    cached_attributes != compare_attributes
  end

  # Updates the local record and cached Salesforce data with either the
  # specified Salesforce object, or by querying Salesforce.
  #
  # Override this as necessary
  def update_from_salesforce(sfo = find_in_salesforce, force = false)
    # TODO: Check verified?  `@Verified__c`
    # TODO: Check deleted? `@IsDeleted`
    return false unless sfo

    sfo = sfo.except(:LastViewedDate, :LastReferencedDate)
    sfo_attributes = self.class.attributes_from_salesforce_object(sfo)

    if !cached_salesforce_object || force || incoming_changes?(sfo_attributes)
      return update_attributes(sfo_attributes).tap do
        salesforce_reference.reload
      end
    end

    attrs = self.class.salesforce_reference_attributes(sfo)
    salesforce_reference.update_attributes(
      attrs.except(:last_imported_from_salesforce_at))
    update_from_cached_salesforce_object
    self
  end

  # Updates the local record and cached Salesforce data with either the
  # specified Salesforce object, or by querying Salesforce.
  #
  # This calls `update_from_salesforce`, but with `force=true`
  def update_from_salesforce!(sfo = find_in_salesforce)
    update_from_salesforce(sfo, true)
  end

  # Indicates whether there are changes to be sent to Salesforce by checking
  # update date/times
  def changed_since_salesforce?
    return true if !salesforce_reference || !salesforce_reference
      .last_imported_from_salesforce_at
    updated_at > salesforce_reference.last_imported_from_salesforce_at
  end

  # Gets the hash of attributes and values matching Salesforce attributes.
  #
  # Override this to build the update hash with attributes and values to update
  # in Salesforce using the format `{ 'salesforceAttribute' => 'value' }`
  def attributes_for_salesforce
    {}
  end

  # Gets the hash of changed attributes and values to update into Salesforce
  # by comparing the attributes_for_salesforce with the specified Salesforce
  # object (or the cached one if none provided)
  def changed_attributes_for_salesforce(sfo = cached_salesforce_object)
    matching_attributes = attributes_for_salesforce
    changed_keys = matching_attributes.keys.select do |key|
      sfo.send(key) != matching_attributes[key]
    end
    matching_attributes.slice(*changed_keys)
  end

  # Provides a means to bypass updating Salesforce.  For example, this is used
  # to prevent the update in Salesforce of a record updated locally from
  # Salesforce.  The following additional checks are also made:
  #
  # - Checks whether there is a corresponding (cached) record from Salesforce
  # - Checks whether there are any known differences from the cached record
  def should_update_salesforce?
    return false if skip_salesforce_sync?
    return false if defined?(deleted_at) && !deleted_at.nil?
    if skip_next_salesforce_update
      self.skip_next_salesforce_update = nil
      return false
    end
    return false unless cached_salesforce_object
    changed_since_salesforce?
  end

  # Schedules the update of an existing record in Salesforce from the changed
  # attributes of this instance into ActiveJob
  # Params:
  # +fields+:: restricts the update to the specified subset (Array) of fields
  #
  # Note: This only updates if there is a corresponding cached record from
  # Salesforce
  def update_salesforce(fields = nil, background = true, force = false)
    return {} if !Spree::Config[:salesforce_enabled]
    return {} if !force && !should_update_salesforce?
    # TODO: Handle both modified case
    sfo = cached_salesforce_object
    # TODO: Handle case where sfo is nil
    attributes_to_update = changed_attributes_for_salesforce(sfo)
    attributes_to_update.slice! fields if fields.present?
    return {} if attributes_to_update.blank?
    if background
      #TODO: We need to call background job for this.
    else
      update_record_in_salesforce(attributes_to_update)
    end
    attributes_to_update
  end
  # Does the work of updating an existing record in Salesforce with the
  # specified attributes for the SObject corresponding to this instance.  Also
  # updates the related salesforce_reference record in the local database
  #
  # This will be called from within ActiveJob
  def update_record_in_salesforce(attributes_to_update = {})
    attributes_with_id = attributes_to_update.merge('Id' => id_in_salesforce)
    last_modified_in_salesforce_at = self.class.date_to_salesforce
    ok = self.class.salesforce_api.update(salesforce_sobject_name,
                                          attributes_with_id)
    return false unless ok
    sfo_attributes = salesforce_reference.object_properties.merge(
      'LastModifiedDate' => last_modified_in_salesforce_at
    )
    updated_sfo_attributes = sfo_attributes.merge(attributes_to_update)
    sfo = salesforce_reference.object_from_properties(updated_sfo_attributes)
    update_from_salesforce(sfo)
    attributes_to_update
  end

  # Provides the hash of attibutes and values for creating a new Salesforce
  # record.
  #
  # Override to customize attributes for create.  For example, if needed this
  # could add `.merge 'OwnerId' => self.class.salesforce_user_id`
  def new_attributes_for_salesforce
    attributes_for_salesforce
  end

  # Provides a means to bypass creation in Salesforce.  For example, this is
  # used to prevent the creation in Salesforce of a record created locally from
  # Salesforce
  def should_create_salesforce?
    return false if skip_salesforce_sync?
    return false if defined?(deleted_at) && !deleted_at.nil?
    !skip_salesforce_create
  end

  # Schedules the create of a new record in Salesforce into ActiveJob
  def create_in_salesforce(fields = nil, background = true)
    return {} if !Spree::Config[:salesforce_enabled]
    return {} unless should_create_salesforce?
    # TODO: Handle both modified case
    attributes_to_create = new_attributes_for_salesforce
    attributes_to_create.slice! fields if fields.present?
    return {} if attributes_to_create.blank?
    ref = salesforce_reference || create_salesforce_reference(object_properties: {})
    if background
      #TODO: We need to call background job for this.
    else
      create_new_record_in_salesforce(attributes_to_create)
    end
    attributes_to_create
  end

  # This will be called from within ActiveJob (create_new_record_in_salesforce)
  def salesforce_create_with_dup_check(attributes_to_create = {})
    return self.class.salesforce_api.create(salesforce_sobject_name,
                                            attributes_to_create), false
  rescue GmSalesforce::DuplicateRecord => e
    return e.duplicate_id, true
  end

  # This will be called from within ActiveJob (create_new_record_in_salesforce)
  def update_from_and_to_new_salesforce_record(new_attrs, duplicate)
    sfo = salesforce_reference.object_from_properties(new_attrs)
    update_from_salesforce(sfo)
    if duplicate
      update_attrs = new_attrs.reject { |key| key.to_s == 'LastModifiedDate' }
      update_record_in_salesforce(update_attrs)
    end
    after_create_salesforce(duplicate)
    sfo
  end

  # Does the work of creating a new record in Salesforce with the specified
  # attributes for the SObject corresponding to this instance.  Also updates
  # the related salesforce_reference record in the local database
  #
  # This will be called from within ActiveJob
  def create_new_record_in_salesforce(attributes_to_create = {})
    created_in_salesforce_at = self.class.date_to_salesforce

    sf_id, duplicate = id_in_salesforce, id_in_salesforce.present?
    unless duplicate
      sf_id, duplicate = salesforce_create_with_dup_check(attributes_to_create)
      return false if sf_id.blank?
    end

    new_attrs = attributes_to_create.merge(
      'Id' => sf_id, 'LastModifiedDate' => created_in_salesforce_at)
    update_from_and_to_new_salesforce_record(new_attrs, duplicate)
  end

  # Performs additional tasks after creating a record in Salesforce.  This will
  # be called from within ActiveJob
  # Params:
  # +_duplicate+:: indicates if the "new" record matched an existing one
  #
  # Override this to perform additional tasks after creating a record in
  # Salesforce
  def after_create_salesforce(_duplicate = false)
    update_from_salesforce!
  end

  class_methods do
    # Gets the SObject name corresponding to this class.  Defaults to class
    # name.
    #
    # Override this to set the object name in Salesforce (e.g. 'Contact')
    def sobject_name
      name
    end

    def date_to_salesforce(date = Time.zone.now)
      GmSalesforce::Client.date_to_salesforce(date)
    end

    # Queries for local records that "match" a given Salesforce object
    #
    # Override this as necessary, for example how to match fields other than ID
    def matches_salesforce_object(sfo)
      return none if sfo.blank?
      joins(:salesforce_reference).where(
        'salesforce_references.id_in_salesforce' => sfo.Id)
    end

    # Queries the SObject in Salesforce corresponding to this class by Id
    def find_in_salesforce_by_salesforce_id(id)
      salesforce_api.find(sobject_name, id)
    end

    # Gets/sets the library to interface with Salesforce
    def salesforce_api
      GmSalesforce::Client.instance
    end

    # Selects all of the columns from all of the records in Salesforce for the
    # SObject corresponding to this class
    def find_all_in_salesforce
      salesforce_api.find_all_in_salesforce(sobject_name)
    end

    # Extracts attributes from a Salesforce object to be used to create/update
    # the related salesforce_reference record
    def salesforce_reference_attributes(sfo)
      {
        id_in_salesforce: sfo.Id,
        last_modified_in_salesforce_at: sfo.LastModifiedDate,
        last_imported_from_salesforce_at: date_to_salesforce,
        object_properties: sfo.to_hash
      }
    end

    # Extracts attributes from a Salesforce object to be used to create/update
    # a local record
    #
    # Override this as necessary adding in attributes to set
    def attributes_from_salesforce_object(sfo)
      {
        skip_next_salesforce_update: true,
        skip_salesforce_create: true,
        salesforce_reference_attributes: salesforce_reference_attributes(sfo)
      }
    end

    # Find a local match (or create if none) for a Salesforce object
    #
    # Override this as necessary, including to prevent creation when no match
    def find_or_create_by_salesforce_object(sfo, &block)
      return nil if sfo.blank?
      matches_salesforce_object(sfo).first_or_create(
        attributes_from_salesforce_object(sfo), &block)
    end

    # This can be used to delete local records not found in (or deleted from)
    # Salesforce.
    #
    # Override this to delete records
    #
    # E.g.: `where.not(id: updated_records.map(&:id)).destroy_all`
    def remove_deleted_records(updated_records)
      return nil if updated_records.blank?
      []
    end

    # Create or update a local record from a Salesforce object
    def create_or_update_record(sfo)
      new_record = false
      local_object = find_or_create_by_salesforce_object(sfo) do
        new_record = true
      end
      if local_object && local_object.salesforce_reference.blank?
        local_object.create_salesforce_reference(id_in_salesforce: sfo.Id)
      end
      if local_object && !new_record && local_object_match_sfo?(local_object, sfo)
        local_object.update_from_salesforce(sfo)
      end
      local_object
    end

    def local_object_match_sfo?(local_object, sfo)
      local_object.id_in_salesforce == sfo.Id
    end

    # Create or update local records from Salesforce objects
    def create_or_update_records(salesforce_objects)
      return nil if salesforce_objects.blank?
      updated_records = []
      salesforce_objects.each do |sfo|
        updated_records << create_or_update_record(sfo)
      end
      updated_records
    end

  end
end
