class CreateSpreeMaterialImportJobs < ActiveRecord::Migration
  def change
    create_table :spree_material_import_jobs do |t|
      t.integer :product_id
      t.integer :user_id
      t.string :status

      t.timestamps null: false
    end
  end
end
