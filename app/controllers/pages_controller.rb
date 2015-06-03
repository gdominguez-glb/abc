class PagesController < ApplicationController
  def show
    @page          = Page.find_by(slug: params[:slug]) || Page.find_by(slug: 'not-found')
    @page_title    = @page.title
    @group_page    = Page.find_by(group_name: @page.group_name, group_root: true)
    @sub_nav_items = Page.show_in_sub_navigation(@page.group_name)

    log_activity(@page)
    if @page.layout.present?
      render layout: @page.layout
    end
  end

  private

  def log_activity(page)
    if spree_current_user
      spree_current_user.log_activity(
        item: page,
        action: 'view',
        title: page.title
      )
    end
  end
end
