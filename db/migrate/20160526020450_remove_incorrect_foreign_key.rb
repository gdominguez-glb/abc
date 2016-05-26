class RemoveIncorrectForeignKey < ActiveRecord::Migration
  def up
    remove_foreign_key "document_taggings", "tags"
    remove_foreign_key "document_taggings", "documents"
  end

  def down
    add_foreign_key "document_taggings", "documents"
    add_foreign_key "document_taggings", "tags"
  end
end
