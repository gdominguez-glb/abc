# SchoolDistrict
class SchoolDistrict < ActiveRecord::Base
  include SalesforceAccess

  belongs_to :state, class_name: 'Spree::State'
  belongs_to :country, class_name: 'Spree::Country'
  has_many :users, class_name: 'Spree::User'

  validates :name, presence: true
  validates :state_id, presence: true, if: Proc.new{ |school_district|
    !school_district.unaffiliated? && school_district.country.try(:name) == 'United States'
  }

  enum place_type: { school: 'school', district: 'district',
                     unaffiliated: 'unaffiliated' }

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
    return self.class.unaffiliated_type_id if unaffiliated?
    nil
  end

  def update_from_cached_salesforce_object
    if cached_salesforce_object
      update(
        sf_is_deleted: cached_salesforce_object.IsDeleted,
        sf_verified: cached_salesforce_object.Verified__c,
        sf_created_at: (Date.parse(cached_salesforce_object.CreatedDate) rescue nil)
      )
    end
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

  def self.record_type_id(name, object_type = 'Account')
    RecordType.find_in_salesforce_by_name_and_object_type(name, object_type)
      .try('Id')
  end

  def self.district_type_id
    @district_type_id ||= record_type_id('District')
  end

  def self.school_type_id
    @school_type_id ||= record_type_id('School')
  end

  def self.unaffiliated_type_id
    @unaffiliated_type_id ||= record_type_id('Unaffiliated')
  end

  def self.place_type_from_salesforce_object(sfo)
    # Base type on the Salesforce RecordType
    case sfo.RecordTypeId
    when school_type_id # RecordType is `School`
      place_types[:school]
    when district_type_id # RecordType is `District`
      place_types[:district]
    when unaffiliated_type_id
      place_types[:unaffiliated] # RecordType is `Unaffiliated`
    else
      sfo.ParentId.blank? ? place_types[:district] : place_types[:school]
    end
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

  # Provides the hash of attibutes and values for creating a new Salesforce
  # record.
  def new_attributes_for_salesforce
    attributes_for_salesforce.merge!('Verified__c' => false)
  end

  def attributes_for_salesforce
    { 'Name' => name,
      'RecordTypeId' => salesforce_record_type_id,
      'BillingState' => state.try(:abbr),
      'BillingCity' => city,
      'Website_ID__c' => id,
      'BillingCountry' => country.try(:iso3) }
  end

  def self.matches_salesforce_object(sfo)
    matches = super(sfo)
    return matches if matches.present?
    return none if sfo.Name.blank?
    state = state_from_salesforce_object(sfo)
    where(name: sfo.Name, state_id: state)
  end

  # Performs additional tasks after creating a record in Salesforce.  This will
  # be called from within ActiveJob
  # Params:
  # +_duplicate+:: indicates if the "new" record matched an existing one
  def after_create_salesforce(duplicate = false)
    super(duplicate)
    salesforce_reference.reload
    users.reload
    users.each do |user|
      next if user.try(:salesforce_reference).present? ||
        !user.should_create_salesforce?
      user.create_in_salesforce(nil, false)
    end
    self.class.import_salesforce
  end

  # The dropdown should be restricted to verified checkbox, last 48 hours, and
  # is not “is deleted"
  scope :for_selection, -> { where("sf_is_deleted = ? and (sf_verified = ? or (sf_verified = ? and sf_created_at > ?))", false, true, false, 2.days.ago) }

  scope :with_state, ->(state_id) {
    where(state_id: state_id) if state_id
  }
end
