class AddCurriculumIdAndGradeIdAndGradeUnitIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :curriculum_id, :integer
    add_column :spree_products, :grade_id, :integer
    add_column :spree_products, :grade_unit_id, :integer
  end
end
