class Cms::MediumPublicationsController < Cms::BaseController
  before_action :set_medium_publication, only: [:show, :edit, :update, :destroy]

  def index
    @medium_publications = MediumPublication.all
  end

  def new
    @medium_publication = MediumPublication.new(blog_type: 'global')
  end

  def create
    @medium_publication = MediumPublication.new(medium_publication_params)
    if @medium_publication.save
      redirect_to cms_medium_publications_path, notice: 'Successfully create new medium publication.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @medium_publication.update(medium_publication_params)
      redirect_to cms_medium_publications_path, notice: 'Successfully updated new medium publication.'
    else
      render :edit
    end
  end

  def destroy
    @medium_publication.destroy
    redirect_to cms_medium_publications_path, notice: 'Successfully deleted new medium publication.'
  end

  private

  def set_medium_publication
    @medium_publication = MediumPublication.find(params[:id])
  end

  def medium_publication_params
    params.require(:medium_publication).permit(:title, :url, :blog_type, :curriculum, :position, :display)
  end
end
