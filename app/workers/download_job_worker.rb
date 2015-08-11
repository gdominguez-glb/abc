require 'fileutils'
require 'net/http'
require 'zip'
require 'zip/file'
require 'find'

class Zipper

  def self.zip(dir, zip_dir, remove_after = false)
    Zip::File.open(zip_dir, Zip::File::CREATE)do |zipfile|
      Find.find(dir) do |path|
        Find.prune if File.basename(path)[0] == ?.
        dest = /#{dir}\/(\w.*)/.match(path)
        # Skip files if they exists
        begin
          zipfile.add(dest[1],path) if dest
        rescue Zip::ZipEntryExistsError
        end
      end
    end
    FileUtils.rm_rf(dir) if remove_after
  end

end

class DownloadJobWorker
  include Sidekiq::Worker

  def perform(download_job_id)
    download_job = DownloadJob.find(download_job_id)

    tmp_directory_path     = Rails.root.join('tmp/download_jobs', download_job_id.to_s)
    tmp_zip_directory_path = Rails.root.join('tmp/download_job_zips')
    zipfile_name           = File.join(tmp_zip_directory_path, "download_#{download_job_id}_#{Time.now.to_i}.zip")

    begin
      materials = Spree::Material.where(id: download_job.material_ids)

      download_job.update(status: 'processing')

      FileUtils.mkdir_p(tmp_directory_path)
      FileUtils.mkdir_p(tmp_zip_directory_path)

      files_to_zip = []
      materials.each do |material|
        material.self_and_descendants.each do |_material|
          parent_names             = _material.self_and_descendants.map(&:name)
          full_file_directory_path = File.join(tmp_directory_path, parent_names.join('/'))

          FileUtils.mkdir_p(full_file_directory_path)

          _material.material_files.each do |material_file|
            file_name = File.join(full_file_directory_path, material_file.file.original_filename)
            material_file.file.copy_to_local_file(:original, file_name)
          end
        end
      end

      Zipper.zip(tmp_directory_path, zipfile_name)

      download_job.update(file: File.new(zipfile_name), status: 'done')

      FileUtils.remove_dir tmp_directory_path
      FileUtils.rm [zipfile_name]
    rescue => exception
      download_job.update(status: 'failed')

      FileUtils.remove_dir tmp_directory_path
      FileUtils.rm [zipfile_name]

      ExceptionNotifier.notify_exception(exception, :data => {:message => "Fail to process download job #{download_job_id}"})
    end
  end
end
