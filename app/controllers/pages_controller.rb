class PagesController < ApplicationController
  def show
    @page          = Page.find_by(slug: params[:slug])

    redirect_to not_found_path and return if @page.nil?

    @page_title    = @page.title
    @group_page    = Page.find_by(group_name: @page.group_name, group_root: true)
    @sub_nav_items = Page.show_in_sub_navigation(@page.group_name)

    set_page_meta_tags(@page)
    log_activity(@page)
    if @page.layout.present?
      render layout: @page.layout
    end
  end

  def not_found
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

  def set_page_meta_tags(page)
    if page.keywords.present? || page.description.present?
      set_meta_tags keywords: page.keywords, description: page.description
    end
  end
end
