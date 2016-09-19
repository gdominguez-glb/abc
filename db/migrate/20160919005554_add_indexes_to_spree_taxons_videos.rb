class AddIndexesToSpreeTaxonsVideos < ActiveRecord::Migration
  def change
    add_index :spree_taxons_videos, :taxon_id
    add_index :spree_taxons_videos, :video_id
    add_index :spree_taxons_videos, :position
  end
end
