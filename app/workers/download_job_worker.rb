require 'fileutils'
require 'net/http'
require 'zip/zip'
require 'find'

class Zipper

  def self.zip(dir, zip_dir, remove_after = false)
    Zip::ZipFile.open(zip_dir, Zip::File::CREATE)do |zipfile|
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
    download_job.update(status: 'processing')

    zipfile_name = generate_zipfile_name(download_job_id)

    begin
      generate_directories(download_job_id)
      download_material_files(download_job, zipfile_name)
      Zipper.zip(tmp_directory_path(download_job_id), zipfile_name)
      DownloadJobMailer.notify(download_job).deliver
      download_job.update(file: File.new(zipfile_name), status: 'done')

      cleanup_directories(download_job_id, zipfile_name)
    rescue => exception
      cleanup_directories(download_job_id, zipfile_name)

      download_job.update(status: 'failed')
      ExceptionNotifier.notify_exception(exception, :data => {:message => "Fail to process download job #{download_job_id}"})
    end
  end

  def generate_directories(download_job_id)
    FileUtils.mkdir_p(tmp_directory_path(download_job_id))
    FileUtils.mkdir_p(tmp_zip_directory_path)
  end

  def download_material_files(download_job, zipfile_name)
    materials = Spree::Material.where(id: download_job.material_ids)
    materials.each do |material|
      material.self_and_descendants.each do |_material|
        download_material_file(download_job, _material)
      end
    end
  end

  def download_material_file(download_job, material)
    full_file_directory_path = generate_full_file_directory_path(download_job, material)
    FileUtils.mkdir_p(full_file_directory_path)
    material.material_files.each do |material_file|
      file_name = File.join(full_file_directory_path, material_file.file.original_filename)
      material_file.file.copy_to_local_file(:original, file_name)
    end
  end

  def generate_full_file_directory_path(download_job, material)
    parent_names = material.self_and_ancestors.map(&:name)
    File.join(tmp_directory_path(download_job.id), parent_names.join('/'))
  end

  def generate_zipfile_name(download_job_id)
    File.join(tmp_zip_directory_path, "download_#{download_job_id}_#{Time.now.to_i}.zip")
  end

  def tmp_directory_path(download_job_id)
    Rails.root.join('tmp/download_jobs', download_job_id.to_s)
  end

  def tmp_zip_directory_path
    Rails.root.join('tmp/download_job_zips')
  end

  def cleanup_directories(download_job_id, zipfile_name)
    FileUtils.remove_dir tmp_directory_path(download_job_id)
    FileUtils.rm [zipfile_name]
  end
end
