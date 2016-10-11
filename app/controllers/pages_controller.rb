class PagesController < ApplicationController
  def show
    @page          = cache [:page_slug, params[:slug]], expires_in: 2.hours do
      Page.find_by(slug: params[:slug])
    end

    redirect_to not_found_path and return if @page.nil?

    @page_title    = @page.title
    @group_page    = cache [@page, :group_page], expires_in: 2.hours do
      Page.find_by(group_name: @page.group_name, group_root: true)
    end
    @sub_nav_items = cache [@page, :sub_nav_items], expires_in: 2.hours do
      Page.show_in_sub_navigation(@page.group_name)
    end

    set_page_meta_tags(@page)
    if @page.layout.present?
      render layout: @page.layout
    end
  end

  def not_found
    render status: 404
  end

  private

  def set_page_meta_tags(page)
    if page.keywords.present? || page.description.present?
      set_meta_tags keywords: page.keywords, description: page.description
    end
  end
end
