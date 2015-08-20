# RecordType
class RecordType < ActiveRecord::Base
  include SalesforceAccess

  def self.sobject_name
    'RecordType'
  end

  # Since this has no table in the database
  def self.columns
    @columns ||= []
  end

  # Since this has no table in the database
  def self.inherited(subclass)
    subclass.instance_variable_set('@columns', columns)
    super
  end

  # Since this has no table in the database
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(
      name.to_s, default, sql_type.to_s, null)
  end

  # Since this has no table in the database
  def save(validate = true)
    validate ? valid? : true
  end

  # Looks for the RecordType by name and object type
  def self.find_in_salesforce_by_name_and_object_type(name, object_type)
    return nil if name.blank? || object_type.blank?
    salesforce_api.client.query("select Id from #{sobject_name} where Name = " \
      "'#{name}' and SobjectType = '#{object_type}'").first
  end
end
