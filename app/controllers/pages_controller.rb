class PagesController < ApplicationController

  def show
    @page = Page.find_by(slug: params[:slug])
    render layout: @page.layout if !@page.layout.blank?
  end
end
