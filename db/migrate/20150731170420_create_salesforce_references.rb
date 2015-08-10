# CreateSalesforceReferences
class CreateSalesforceReferences < ActiveRecord::Migration
  def change
    create_table :salesforce_references do |t|
      t.string :id_in_salesforce, limit: 20
      t.integer :local_object_id, null: false
      t.string :local_object_type, null: false, limit: 50
      t.datetime :last_modified_in_salesforce_at
      t.datetime :last_imported_from_salesforce_at
      t.text :object_properties

      t.timestamps null: false
    end

    add_index :salesforce_references, :id_in_salesforce
    add_index :salesforce_references, [:local_object_id, :local_object_type],
              name: 'index_salesforce_references_on_local_object_reference'
  end
end
