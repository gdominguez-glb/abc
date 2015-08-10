# SalesforceReference
class SalesforceReference < ActiveRecord::Base
  belongs_to :local_object, polymorphic: true

  serialize :object_properties

  def object_from_properties(properties = object_properties)
    return nil if properties.blank?
    Hashie::Mash.new(properties)
  end

  def update_properties_from_object(sfo)
    update(:object_properties, sfo.to_hash)
  end
end
