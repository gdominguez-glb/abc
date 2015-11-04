class Cms::CurriculumShopsController < Cms::BaseController
  before_action :set_curriculum_shop, only: [:show, :edit, :update, :destroy]

  def index
    @curriculum_shops = CurriculumShop.page(params[:page])
  end

  def show
  end

  def new
    @curriculum_shop = CurriculumShop.new
  end

  def edit
  end

  def create
    @curriculum_shop = CurriculumShop.new(curriculum_shop_params)

    if @curriculum_shop.save
      redirect_to cms_curriculum_shops_path, notice: 'CurriculumShop was successfully created.'
    else
      render :new
    end
  end

  def update
    if @curriculum_shop.update(curriculum_shop_params)
      redirect_to cms_curriculum_shops_path, notice: 'CurriculumShop was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @curriculum_shop.destroy
    redirect_to cms_curriculum_shops_url, notice: 'CurriculumShop was successfully destroyed.'
  end

  private

  def set_curriculum_shop
    @curriculum_shop = CurriculumShop.find(params[:id])
  end

  def curriculum_shop_params
    params.require(:curriculum_shop).permit(:title, :url, :page_id)
  end
end
