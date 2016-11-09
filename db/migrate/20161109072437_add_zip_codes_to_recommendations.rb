class AddZipCodesToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :zip_codes, :string
  end
end
