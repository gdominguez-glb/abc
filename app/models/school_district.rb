# SchoolDistrict
class SchoolDistrict < ActiveRecord::Base
  include SalesforceAccess

  belongs_to :state, class_name: 'Spree::State'

  enum place_type: { school: 'school', district: 'district' }

  def self.sobject_name
    'Account'
  end

  # We do not want any School/District updates going to Salesforce.  Instead
  # of updating records, create new records and reassign `Spree:User` records
  # to the new SchoolDistrict records.
  def should_update_salesforce?
    false
  end

  def salesforce_record_type_id
    return self.class.school_type_id if school?
    return self.class.district_type_id if district?
    nil
  end

  # Looks for name + state, then looks for just name if not found
  def find_in_salesforce_by_name_and_state
    return nil if name.blank?
    sfo = self.class.salesforce_api.client.query(
      "select Id from #{salesforce_sobject_name} where Name = " \
      "'#{name}' and BillingState = '#{state.try(:abbr)}'").first
    return sfo if sfo
    self.class.salesforce_api.client.query(
      "select Id from #{salesforce_sobject_name} where Name = '#{name}'").first
  end

  def self.district_type_id
    @district_type_id ||= RecordType
      .find_in_salesforce_by_name_and_object_type('District', 'Account')
      .try('Id')
  end

  def self.school_type_id
    @school_type_id ||= RecordType
      .find_in_salesforce_by_name_and_object_type('School', 'Account')
      .try('Id')
  end

  def self.place_type_from_salesforce_object(sfo)
    # If the Salesforce RecordType is `School`, it is a school
    return place_types[:school] if sfo.RecordTypeId == school_type_id
    # If the Salesforce RecordType is `District`, it is a district
    return place_types[:district] if sfo.RecordTypeId == district_type_id

    # Otherwise, if the Salesforce Account has children, assume it is a district
    sfo.ParentId.blank? ? place_types[:district] : place_types[:school]
  end

  def self.country_from_salesforce_object(sfo)
    return nil if sfo.BillingCountry.blank?
    Spree::Country.find_by(iso: sfo.BillingCountry).try(:iso3)
  end

  def self.state_from_salesforce_object(sfo)
    # TODO: Handle other countries
    return nil if sfo.BillingState.blank?
    us = Spree::Country.find_by(iso: 'US')
    sfo.BillingState.present? && us && us.states.find_by(abbr: sfo.BillingState)
  end

  def self.attributes_from_salesforce_object(sfo)
    sfo_data = super(sfo)
    sfo_data.merge!(name: sfo.Name,
                    place_type: place_type_from_salesforce_object(sfo))
    state = state_from_salesforce_object(sfo)
    sfo_data.merge!(state_id: state.id) if state
    sfo_data
  end

  def attributes_for_salesforce
    { 'Name' => name,
      'RecordTypeId' => salesforce_record_type_id,
      'BillingState' => state.try(:abbr),
      'Website_ID__c' => id,
      'BillingCountry' => state.try(:country).try(:iso3) }
  end

  def self.matches_salesforce_object(sfo)
    matches = super(sfo)
    return matches if matches.present?
    return none if sfo.Name.blank?
    state = state_from_salesforce_object(sfo)
    where(name: sfo.Name, state_id: state)
  end
end
