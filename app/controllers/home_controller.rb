class HomeController < ApplicationController
  def index
    @page = Page.find_by(slug: '/')
  end

  def turn_off_browser_warning
    session[:turn_off_browser_warning] = 'true'
    render nothing: true
  end
end
