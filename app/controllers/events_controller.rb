class EventsController < ApplicationController
  def index
    @events = RegonlineEvent.page(params[:page])
    if params[:zipcode].present?
      @events = @events.near(params[:zipcode], 100)
    end
  end

  def page
    @group_page    = Page.show_in_top_navigation.find_by(slug: params[:page_slug])
    @sub_nav_items = Page.show_in_sub_navigation(@group_page.group_name)

    @event_page = @group_page.event_page
    @events = @event_page.events.page(params[:page])
  end

  def show
    @event = RegonlineEvent.find(params[:id])
  end
end
