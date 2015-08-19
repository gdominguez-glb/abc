class CreateTaxonsVideos < ActiveRecord::Migration
  def change
    create_table :spree_taxons_videos do |t|
      t.integer :video_id
      t.integer :taxon_id
      t.integer :position
    end
  end
end
