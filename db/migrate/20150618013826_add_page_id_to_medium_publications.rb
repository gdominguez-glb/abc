class AddPageIdToMediumPublications < ActiveRecord::Migration
  def up
    add_column :medium_publications, :page_id, :integer
    remove_column :medium_publications, :curriculum
  end

  def down
    add_column :medium_publications, :curriculum, :string
    remove_column :medium_publications, :page_id
  end
end
