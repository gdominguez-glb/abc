require 'material_zip_importer'

class MaterialImporter
  def import_from_material_job(material_import_job_id)
    material_import_job = Spree::MaterialImportJob.find(material_import_job_id)
    material_import_job.update(status: 'processing')

    begin
      FileUtils.mkdir_p(tmp_directory_path(material_import_job))

      material_import_job.file.copy_to_local_file(:original, zip_file_path(material_import_job))

      MaterialZipImporter.new(
        product: material_import_job.product,
        zip_file_path: zip_file_path(material_import_job),
        dest_directory_path: raw_file_directory_path(material_import_job)
      ).import

      material_import_job.update(status: 'done')

      FileUtils.rm_rf(tmp_directory_path(material_import_job))
    rescue => exception
      material_import_job.update(status: 'failed')
      ExceptionNotifier.notify_exception(exception, :data => {:message => "Fail to process import job #{material_import_job_id}"})
    end
  end

  def tmp_directory_path(material_import_job)
    Rails.root.join('tmp/material_import_jobs', material_import_job.id.to_s)
  end

  def zip_file_path(material_import_job)
    File.join(tmp_directory_path(material_import_job), material_import_job.file.original_filename)
  end

  def raw_file_directory_path(material_import_job)
    File.join(tmp_directory_path(material_import_job), 'raw')
  end

end
