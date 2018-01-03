class PagesController < ApplicationController
  def show
    @page          = cache [:page_slug, params[:slug]], expires_in: 2.hours do
      Page.published.unarchive.find_by(slug: params[:slug])
    end

    redirect_to not_found_path and return if @page.nil?
    send(@page.render) and return if @page.render.present?

    @page_title = @page.title
    @seo_title = @page.seo_data.try(:[], :title)
    @group_page = cache [@page, :group_page], expires_in: 2.hours do
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

  def in_the_news
    @in_the_news = InTheNew.latest_by_article_date

    if params[:q].blank?
      @in_the_news = InTheNew.latest_by_article_date
    else
      @in_the_news = InTheNew.search(params[:q], order: {article_date: :desc}).results
    end

    render :in_the_news
  end

  def data_stories
    render :data_stories
  end

  def not_found
    render status: 404
  end

  def testimonials_video
    @wistia_hashed_id = params[:wisitia_video_id]
  end

  def facebook_video
    @facebook_video_url = params[:url]
  end
end
