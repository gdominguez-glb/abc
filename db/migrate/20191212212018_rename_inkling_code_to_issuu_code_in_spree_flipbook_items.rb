class RenameInklingCodeToIssuuCodeInSpreeFlipbookItems < ActiveRecord::Migration
  def change
    rename_column :spree_flipbook_items, :inkling_code, :issuu_code
  end
end
