class Cms::VanityUrlsController < Cms::BaseController
  skip_before_action :authenticate_admin_in_cms!
  before_action :authenticate_vanity_admin_in_cms!

  def index
    @vanity_urls = VanityUrl.page(params[:page])
    if params[:url_q].present?
      @vanity_urls = @vanity_urls.search_url(params[:url_q])
    end
    if params[:tag_q].present?
      @vanity_urls = @vanity_urls.tagged_with(params[:tag_q])
    end
    if params[:category].present?
      @vanity_urls = @vanity_urls.where("category ilike ?", "%#{params[:category]}%")
    end
  end

  def new
    @vanity_url = VanityUrl.new
  end

  def create
    @vanity_url = VanityUrl.new(vanity_url_params)
    if @vanity_url.save
      redirect_to cms_vanity_urls_path, notice: 'Successfully created new vanity url.'
    else
      render :new
    end
  end

  def edit
    @vanity_url = VanityUrl.find(params[:id])
  end

  def update
    @vanity_url = VanityUrl.find(params[:id])
    if @vanity_url.update(vanity_url_params)
      redirect_to cms_vanity_urls_path, notice: 'Successfully updated new vanity url.'
    else
      render :edit
    end
  end

  def destroy
    @vanity_url = VanityUrl.find(params[:id])
    @vanity_url.destroy
    redirect_to cms_vanity_urls_path, notice: 'Successfully deleted new vanity url.'
  end

  private

  def vanity_url_params
    params.require(:vanity_url).permit(:url, :redirect_url, :tag_list, :base_domain, :url_path, :category)
  end

end
