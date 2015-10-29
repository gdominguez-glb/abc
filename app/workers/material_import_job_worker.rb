require 'material_importer'

class MaterialImportJobWorker
  include Sidekiq::Worker
  
  def perform(material_import_job_id)
    MaterialImporter.new.import_from_material_job(material_import_job_id)
  end
end
