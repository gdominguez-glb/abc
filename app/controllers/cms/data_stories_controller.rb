class Cms::DataStoriesController < Cms::BaseController
  before_action :find_page,  only: [:index, :save_page]

  def index
  end

  def save_page
    if @page.update(page_params)
      redirect_to cms_data_stories_path, notice: 'Updated successfully!'
    else
      render :edit_page
    end
  end

  private

  def find_page
    @page = Page.find_by(slug: 'data')
  end

  def page_params
    params.require(:page).permit({:data => [:jumbotron_image, :short_description]}, :title, :slug)
  end
end
