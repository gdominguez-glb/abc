class CreateSpreeGradesProducts < ActiveRecord::Migration
  def change
    create_join_table(:grades, :products, table_name: :spree_grades_products)
  end
end
