require 'fileutils'
require 'net/http'
require 'zip'
require 'zip/file'
require 'find'

class DownloadJobWorker
  include Sidekiq::Worker

  def perform(download_job_id)
    download_job           = DownloadJob.find(download_job_id)
    materials              = Spree::Material.where(id: download_job.material_ids)
    tmp_directory_path     = Rails.root.join('tmp/download_jobs', download_job_id.to_s)
    tmp_zip_directory_path = Rails.root.join('tmp/download_job_zips')

    download_job.update(status: 'processing')

    FileUtils.mkdir_p(tmp_directory_path)
    FileUtils.mkdir_p(tmp_zip_directory_path)

    files_to_zip = []
    materials.each do |material|
      material.material_files.each do |material_file|
        material_file.file.copy_to_local_file(:original, File.join(tmp_directory_path, material_file.file.original_filename))
        files_to_zip << material_file.file.original_filename
      end
    end

    zipfile_name = File.join(tmp_zip_directory_path, "download_#{download_job_id}_#{Time.now.to_i}.zip")

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      files_to_zip.each do |filename|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(filename, File.join(tmp_directory_path,filename))
      end
    end

    download_job.update(file: File.new(zipfile_name), status: 'done')
  end
end
