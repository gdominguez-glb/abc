class HomeController < ApplicationController
  def index
    @page = Page.find_by(slug: '/')
  end
end
