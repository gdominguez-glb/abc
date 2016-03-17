class Cms::CustomCssesController < Cms::BaseController

  def index
    @custom_csses = CustomCss.page(params[:page])
  end

  def new
    @custom_css = CustomCss.new
  end

  def create
    @custom_css = CustomCss.new(custom_css_params)
    if @custom_css.save
      redirect_to cms_custom_csses_path, notice: 'Successfully created custom css.'
    else
      render :new
    end
  end

  def edit
    @custom_css = CustomCss.find(params[:id])
  end

  def update
    @custom_css = CustomCss.find(params[:id])
    if @custom_css.update(custom_css_params)
      redirect_to cms_custom_csses_path, notice: 'Successfully updated custom css.'
    else
      render :edit
    end
  end

  def destroy
    @custom_css = CustomCss.find(params[:id])
    @custom_css.destroy
    redirect_to cms_custom_csses_path, notice: 'Successfully deleted custom css.'
  end

  private

  def custom_css_params
    params.require(:custom_css).permit(:name, :content, :custom_type, :page_id)
  end
end
