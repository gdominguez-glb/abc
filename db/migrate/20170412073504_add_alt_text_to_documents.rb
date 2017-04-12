class AddAltTextToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :alt_text, :string
  end
end
