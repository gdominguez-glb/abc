class HomeController < ApplicationController
  def index
    @page = Rails.cache.fetch(:home_page, expires_in: 2.hours) do
      Page.find_by(slug: '/')
    end
    set_page_meta_tags(@page)
    respond_to :html
  end

  def turn_off_browser_warning
    session[:turn_off_browser_warning] = 'true'
    render nothing: true
  end

  def set_filter_preferences
    session[:filter_role] = params[:role]
    session[:filter_curriculum] = params[:curriculum]
    render nothing: true
  end
end
