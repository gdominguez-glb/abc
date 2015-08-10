class AddFileToSpreeMaterialImportJobs < ActiveRecord::Migration
  def up
    add_attachment :spree_material_import_jobs, :file
  end

  def down
    remove_attachment :spree_material_import_jobs, :file
  end
end
