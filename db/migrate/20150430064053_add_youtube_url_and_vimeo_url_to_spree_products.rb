class AddYoutubeUrlAndVimeoUrlToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :youtube_url, :string
    add_column :spree_products, :vimeo_url, :string
  end
end
