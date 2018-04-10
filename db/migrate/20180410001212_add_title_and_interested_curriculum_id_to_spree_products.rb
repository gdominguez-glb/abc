class AddTitleAndInterestedCurriculumIdToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :title, :string
    add_column :spree_products, :interested_curriculum_id, :integer
  end
end
