class HomeController < ApplicationController
  def index
    @page = Rails.cache.fetch(:home_page, expires_in: 2.hours) do
      Page.find_by(slug: '/')
    end

    rotate_testimonials_index
    set_page_meta_tags(@page)

    respond_to :html
  end

  def turn_off_browser_warning
    session[:turn_off_browser_warning] = 'true'
    render body: nil
  end

  def set_filter_preferences
    session[:filter_role] = params[:role]
    session[:filter_curriculum] = params[:curriculum]
    render body: nil
  end

  def rotate_testimonials_index
    if cookies[:testimonial_index].blank?
      cookies[:testimonial_index] = 1
    else
      cookies[:testimonial_index] = cookies[:testimonial_index].to_i + 1
    end
    cookies[:testimonial_index] = 1 if cookies[:testimonial_index] > 3
  end
end
