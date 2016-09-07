class AddHeaderAndDescriptionToMediumPublications < ActiveRecord::Migration
  def change
    add_column :medium_publications, :header, :string
    add_column :medium_publications, :description, :text
  end
end
