class PagesController < ApplicationController

  def show
    @page = Page.find_by(slug: params[:slug]) || Page.find_by(slug: 'not-found')
    @sub_nav_items = Page.show_in_sub_navigation(@page.group_name)
    if @page.layout.present?
      render layout: @page.layout
    end
  end
end
