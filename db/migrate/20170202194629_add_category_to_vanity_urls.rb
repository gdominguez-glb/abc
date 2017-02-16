class AddCategoryToVanityUrls < ActiveRecord::Migration
  def change
    add_column :vanity_urls, :category, :string
  end
end
