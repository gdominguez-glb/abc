class PagesController < ApplicationController

  def show
    @page = Page.find_by(slug: params[:slug]) || Page.find_by(slug: 'not-found')
    if @page.try(:layout) && !@page.layout.blank?
      render layout: @page.layout
    end
  end
end
