class Cms::WhatNewsController < Cms::BaseController
  before_action :set_what_new, only: [:edit, :update, :destroy]

  def index
    @what_news = WhatNew.page(params[:page]).per(params[:per_page])
  end

  def new
    @what_new = WhatNew.new
  end

  def create
    @what_new = WhatNew.new(what_new_params)
    if @what_new.save
      redirect_to cms_what_news_path, notice: 'Create successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @what_new.update(what_new_params)
      redirect_to cms_what_news_path, notice: 'Update successfully!'
    else
      render :edit
    end
  end

  def destroy
    @what_new.destroy
    redirect_to cms_what_news_path, notice: 'Delete successfully'
  end

  private
  def set_what_new
    @what_new = WhatNew.find(params[:id])
  end

  def what_new_params
    _params = params.require(:what_new).permit(:title, :subject, :display, :call_to_action_button_text, :call_to_action_button_link, :call_to_action_button_target, :product_ids, :user_title, :zip_codes)
    _params[:product_ids] = _params[:product_ids].split(',')
    _params
  end
end
