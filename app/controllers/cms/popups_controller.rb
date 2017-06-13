class Cms::PopupsController < Cms::BaseController
  before_action :find_popup, only: [:edit, :update, :destroy]

  def index
    @popups = Popup.latest.page(params[:page]).per(params[:per_page])
  end

  def new
    @popup = Popup.new
  end

  def create
    @popup = Popup.new(popup_params)
    if @popup.save
      redirect_to cms_popups_path, notice: 'Created popup successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @popup.update(popup_params)
      redirect_to cms_popups_path, notice: 'Updated popup successfully!'
    else
      render :edit
    end
  end

  def destroy
    @popup.destroy
    redirect_to cms_popups_path, notice: 'Delete successfully'
  end

  private

  def find_popup
    @popup = Popup.find(params[:id])
  end

  def popup_params
    params.require(:popup).permit(:title, :body, :slug, :button_link, :button_text, :text_color, :background_color, :starts_at, :expires_at)
  end
end
