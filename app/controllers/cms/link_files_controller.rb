class Cms::LinkFilesController < Cms::BaseController
  before_action :find_link_file, only: [:show, :edit, :destroy, :update]
  layout 'cms_admin'

  def index
    @link_files = LinkFile.page(params[:page]).per(params[:per_page])
  end

  def new
    @link_file = LinkFile.new
  end

  def create
    @link_file = LinkFile.find_by(file_file_name: link_file_params[:file].original_filename) || LinkFile.new(link_file_params)
    if @link_file.save
      redirect_to cms_link_files_path, notice: "Link upload created successfully!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @link_file.update(link_file_params)
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
end
