class Cms::FaqCategoriesController < Cms::BaseController
  before_action :find_faq_category, except: [:index, :new, :create, :update_positions]

  def index
    @faq_categories = FaqCategory.order('position asc')
  end

  def new
    @faq_category = FaqCategory.new
  end

  def create
    @faq_category = FaqCategory.new(faq_category_params)
    if @faq_category.save
      redirect_to cms_faq_categories_path, notice: 'Created contact topic successfully!'
    else
      render :edit
    end
  end

  def edit
  end

  def update
    if @faq_category.update(faq_category_params)
      redirect_to cms_faq_categories_path, notice: 'Updated contact topic successfully!'
    else
      render :edit
    end
  end

  def destroy
    @faq_category.destroy
    redirect_to cms_faq_categories_path, notice: 'Deleted contact topic successfully!'
  end

  def update_positions
    update_positions_with_klass(FaqCategory)
    render nothing: true
  end

  private

  def find_faq_category
    @faq_category = FaqCategory.find(params[:id])
  end

  def faq_category_params
    params.require(:faq_category).permit(:name, :display)
  end
end
