class CreateProductsRecommendations < ActiveRecord::Migration
  def change
    create_table :products_recommendations, id: false do |t|
      t.integer :product_id
      t.integer :recommendation_id
    end
  end
end
