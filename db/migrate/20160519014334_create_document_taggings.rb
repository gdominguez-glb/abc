class CreateDocumentTaggings < ActiveRecord::Migration
  def change
    create_table :document_taggings do |t|
      t.belongs_to :document, index: true
      t.belongs_to :tag, index: true

      t.timestamps null: false
    end
    add_foreign_key :document_taggings, :documents
    add_foreign_key :document_taggings, :tags
  end
end
