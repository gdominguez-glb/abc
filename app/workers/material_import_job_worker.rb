require 'fileutils'
require 'net/http'
require 'zip'
require 'zip/file'
require 'find'

class MaterialImportJobWorker
  include Sidekiq::Worker
  
  def perform(material_import_job_id)
    material_import_job = Spree::MaterialImportJob.find(material_import_job_id)
    material_import_job.update(status: 'processing')

    begin
      FileUtils.mkdir_p(tmp_directory_path(material_import_job))

      material_import_job.file.copy_to_local_file(:original, zip_file_path(material_import_job))
      extract_zip_file(zip_file_path(material_import_job), raw_file_directory_path(material_import_job))
      process_root_directory(material_import_job)

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

  def extract_zip_file(zip_file_path, dest_directory)
    Zip::File.open(zip_file_path) do |zip_file|
      zip_file.each do |entry|
        file_path= File.join(dest_directory, entry.name)
        FileUtils.mkdir_p(File.dirname(file_path))
        zip_file.extract(entry, file_path) unless File.exist?(file_path)
        puts "Extracting #{entry.name}"
      end
    end
  end

  def process_root_directory(material_import_job)
    product             = material_import_job.product
    root_directory_path = File.join(raw_file_directory_path(material_import_job), product.name)
    return unless File.exists?(root_directory_path)
    dir = Dir.new(root_directory_path)
    dir.entries.each do |sub_dir_name|
      sub_dir_path = File.join(root_directory_path, sub_dir_name)
      next if sub_dir_name.start_with?('.')
      next if !File.directory?(sub_dir_path)
      process_directory(product, nil, sub_dir_path)
    end
  end

  def process_directory(product, parent, directory_path)
    dir = Dir.new(directory_path)
    material = Spree::Material.create(
      name: File.basename(directory_path),
      parent: parent,
      product: product
    )
    dir.entries.each do |file_name|
      next if file_name.start_with?('.')
      path = File.join(directory_path, file_name)
      if File.directory?(path)
        process_directory(product, material, path)
      else
        create_material_file(material, path)
      end
    end
  end

  def create_material_file(material, file_path)
    file = File.new(file_path)
    Spree::MaterialFile.create(
      material: material,
      file: file
    )
  end
end
