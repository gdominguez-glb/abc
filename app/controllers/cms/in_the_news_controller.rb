class Cms::InTheNewsController < Cms::BaseController
  before_action :find_in_the_news, only: [:edit, :update, :destroy]

  def index
    @in_the_news = InTheNew.page(params[:page]).per(params[:per_page])
  end

  def new
    @in_the_new = InTheNew.new
  end

  def create
    @in_the_new = InTheNew.new(in_the_new_params)
    if @in_the_new.save
      redirect_to cms_in_the_news_path, notice: 'Created successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @in_the_new.update(in_the_new_params)
      redirect_to cms_in_the_news_path, notice: 'Updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @in_the_new.destroy
    redirect_to cms_in_the_news_path, notice: 'Delete successfully'
  end

  private

  def find_in_the_news
    @in_the_new = InTheNew.find(params[:id])
  end

  def in_the_new_params
    params.require(:in_the_new).permit(
      :article_date, :author,
      :call_to_action_button_link,
      :call_to_action_button_target,
      :call_to_action_button_text,
      :description,
      :image_url,
      :publisher,
      :slug,
      :title
    )
  end
end
