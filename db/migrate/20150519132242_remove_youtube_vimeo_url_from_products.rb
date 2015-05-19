class RemoveYoutubeVimeoUrlFromProducts < ActiveRecord::Migration
  def up
    remove_column :spree_products, :youtube_url
    remove_column :spree_products, :vimeo_url
  end

  def down
    add_column :spree_products, :youtube_url, :string
    add_column :spree_products, :vimeo_url, :string
  end
end
