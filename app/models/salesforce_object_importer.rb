class SalesforceObjectImporter

  def initialize(sobject_name, klass)
    @sobject_name = sobject_name
    @klass = klass
  end

  def import
    count = 0
    client = GmSalesforce::Client.instance
    client.find_all_in_salesforce_by_pagination(@sobject_name) do |salesforce_objects|
      count += salesforce_objects.count
      updated_records = @klass.create_or_update_records(salesforce_objects)
      @klass.remove_deleted_records(updated_records)
    end
    count
  end
end
