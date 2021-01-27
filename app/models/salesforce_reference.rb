# SalesforceReference
class SalesforceReference < ApplicationRecord
  belongs_to :local_object, polymorphic: true

  serialize :object_properties

  # Gets a Salesforce object from specified (or cached) Salesforce properties
  def object_from_properties(properties = object_properties)
    return nil if properties.blank?
    Hashie::Mash.new(properties)
  end

  # Updates the cached Salesforce properties from a given Salesforce object
  def update_properties_from_object(sfo)
    update(object_properties: sfo.to_hash)
  end
end
