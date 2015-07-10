class AddSubjectToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :subject, :string
  end
end
