require 'fileutils'
require 'net/http'
require 'zip/zip'
require 'find'

class MaterialZipImporter
  attr_accessor :product, :zip_file_path, :dest_directory_path, :raw_file_directory_path

  def initialize(attrs={})
    @product                 = attrs[:product]
    @zip_file_path           = attrs[:zip_file_path]
    @dest_directory_path     = attrs[:dest_directory_path]
    @raw_file_directory_path = File.join(@dest_directory_path, "#{@product.name}_#{Time.now.to_i}")
  end

  def import
    extract_zip_file
    @product.materials.destroy_all
    process_root_directory
  end

  def extract_zip_file
    Zip::ZipFile.open(zip_file_path) do |zip_file|
      zip_file.each do |entry|
        file_path= File.join(raw_file_directory_path, entry.name.downcase)
        FileUtils.mkdir_p(File.dirname(file_path))
        zip_file.extract(entry, file_path) unless File.exist?(file_path)
        puts "Extracting #{entry.name.downcase}"
      end
    end
  end

  def find_root_directory
    Dir.new(raw_file_directory_path).each do |file_name|
      return File.join(raw_file_directory_path, file_name) if file_name == @product.name.downcase
    end
  end

  def process_root_directory
    root_directory_path = find_root_directory
    return unless File.exists?(root_directory_path)
    dir = Dir.new(root_directory_path)
    dir.entries.sort.each_with_index do |sub_dir_name, index|
      sub_dir_path = File.join(root_directory_path, sub_dir_name)
      next if sub_dir_name.start_with?('.')
      next if !File.directory?(sub_dir_path)
      process_directory(product, nil, sub_dir_path, index)
    end
  end

  def process_directory(product, parent, directory_path, position)
    dir = Dir.new(directory_path)
    name = revise_grade_in_name( titleize_and_keep_dashes(File.basename(directory_path).gsub(/^\d+ /, '')) )
    return if (/macosx/i).match(name)
    material = Spree::Material.create(
      name: name,
      parent: parent,
      product: product,
      position: position
    )
    dir.entries.sort.each_with_index do |file_name, position|
      next if file_name.start_with?('.')
      path = File.join(directory_path, file_name)
      if File.directory?(path)
        process_directory(product, material, path, position)
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

  def revise_grade_in_name(name)
    if name =~ /\((.*\ \d+)\)$/
      grade = $1.split(' ').map(&:upcase).join('-')
      name = name.gsub(/\(.*\ \d+\)$/, "(#{grade})")
    end
    name
  end

  def titleize_and_keep_dashes(text)
    text.split.map(&:capitalize).join(' ').split('-').map(&:titleize).join('-')
  end
end
