class AddSlugToMediumPublications < ActiveRecord::Migration
  def change
    add_column :medium_publications, :slug, :string
  end
end
