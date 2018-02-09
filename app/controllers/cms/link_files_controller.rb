class Cms::LinkFilesController < Cms::BaseController
  before_action :find_link_file, only: [:show, :edit, :destroy, :update]
  layout 'cms_admin'

  def index
    @q = LinkFile.ransack(params[:q])
    @link_files = @q.result.page(params[:page]).per(params[:per_page])
  end

  def new
    @link_file = LinkFile.new
  end

  def create
    if params[:link_file].blank?
      flash[:error] = "Please upload a file to continue."
      redirect_to new_cms_link_file_path and return
    end
    @link_files = build_link_files
    @link_files.each {|lf| lf.save }

    redirect_to cms_link_files_path, notice: "Link upload created successfully!"
  end

  def edit
  end

  def update
    if @link_file.update(link_file_params)
      LinkFileInvalidatorWorker.perform_async(@link_file.id)
      redirect_to cms_link_files_path, notice: "Updated link upload successfully"
    else
      render :edit
    end
  end

  def destroy
    @link_file.destroy
    redirect_to cms_link_files_path, notice: "Deleted link upload successfully"
  end

  protected

  def link_file_params
    params.require(:link_file).permit(:file)
  end

  def find_link_file
    @link_file = LinkFile.find(params[:id])
  end

  def build_link_files
    if File.extname(link_file_params[:file].original_filename) == '.zip'
      build_link_files_from_zip(link_file_params[:file].path)
    else
      [build_link_file(link_file_params[:file])]
    end
  end

  def build_link_files_from_zip(zip_file_path)
    link_files = []
    tmp_directory = Rails.root.join("tmp/link_files/files_#{Time.now.to_i}")
    FileUtils.mkdir_p(tmp_directory)
    Zip::ZipFile.open(zip_file_path) do |zip_file|
      zip_file.each do |entry|
        next if entry.name.start_with?('.') || entry.name.start_with?('__')
        file_path = File.join(tmp_directory, entry.name)
        FileUtils.mkdir_p(File.dirname(file_path))
        zip_file.extract(entry, file_path)
        if File.exist?(file_path) && !File.directory?(file_path)
          link_files << build_link_file(File.new(file_path))
        end
      end
    end
    link_files
  end

  def build_link_file(file)
    file_name = file.respond_to?(:original_filename) ? file.original_filename : File.basename(file.path)
    LinkFile.find_by(file_file_name: file_name) || LinkFile.new(file: file)
  end
end
