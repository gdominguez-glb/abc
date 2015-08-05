class AddIsGradesProductToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :is_grades_product, :boolean, default: false
  end
end
