class HomeController < ApplicationController
  def index
    @page = Rails.cache.fetch(:home_page, expires_in: 2.hours) do
      Page.find_by(slug: '/')
    end
  end

  def turn_off_browser_warning
    session[:turn_off_browser_warning] = 'true'
    render nothing: true
  end
end
