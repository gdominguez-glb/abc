class CreateOpportunities < ActiveRecord::Migration
  def change
    create_table :opportunities do |t|
      t.string :salesforce_id
      t.timestamps null: false
    end
  end
end
