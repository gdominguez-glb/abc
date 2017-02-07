class CreateOpportunityAttachments < ActiveRecord::Migration
  def change
    create_table :opportunity_attachments do |t|
      t.attachment :file
      t.references :opportunity
      t.timestamps null: false
    end
  end
end
