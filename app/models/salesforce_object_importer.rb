class SalesforceObjectImporter

  def initialize(sobject_name, klass)
    @sobject_name = sobject_name
    @klass = klass
  end

  def import(import_all=false)
    count = 0
    client = GmSalesforce::Client.instance

    params = [@sobject_name]

    if !import_all
      params.concat([
        client.columns(@sobject_name).join(','),
        "LastModifiedDate > #{GmSalesforce::Client.date_to_salesforce(22.minutes.ago)}"
      ])
    end

    client.find_all_in_salesforce_by_pagination(*params) do |salesforce_objects|
      count += salesforce_objects.count
      updated_records = @klass.create_or_update_records(salesforce_objects)
      @klass.remove_deleted_records(updated_records)
    end
    count
  end
end
