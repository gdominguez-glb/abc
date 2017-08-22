class ChangeIdInSalesforceLengthInSalesforceReferences < ActiveRecord::Migration
  def change
    change_column(:salesforce_references, :id_in_salesforce, :string, limit: 30)
  end
end
