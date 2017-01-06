class Cms::WhatsNewsController < Cms::BaseController
  before_action :set_whats_new, only: [:edit, :update, :destroy]

  def index
    @whats_news = WhatsNew.latest.page(params[:page]).per(params[:per_page])
  end

  def new
    @whats_new = WhatsNew.new
  end

  def create
    @whats_new = WhatsNew.new(whats_new_params)
    if @whats_new.save
      redirect_to cms_whats_news_path, notice: 'Create successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @whats_new.update(whats_new_params)
      redirect_to cms_whats_news_path, notice: 'Update successfully!'
    else
      render :edit
    end
  end

  def destroy
    @whats_new.destroy
    redirect_to cms_whats_news_path, notice: 'Delete successfully'
  end

  private
  def set_whats_new
    @whats_new = WhatsNew.find(params[:id])
  end

  def whats_new_params
    _params = params.require(:whats_new).permit(:title, :sub_header, :subject, :display, :url, :call_to_action_button_text, :call_to_action_button_link, :call_to_action_button_target, :product_ids, :user_title, :zip_codes)
    _params[:product_ids] = _params[:product_ids].split(',')
    _params
  end
end
