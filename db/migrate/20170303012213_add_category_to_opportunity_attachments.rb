class AddCategoryToOpportunityAttachments < ActiveRecord::Migration
  def change
    add_column :opportunity_attachments, :category, :string
  end
end
