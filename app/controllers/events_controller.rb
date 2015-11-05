class EventsController < ApplicationController
  def index
    @events = RegonlineEvent.displayable.sorted.page(params[:page])
    filter_by_zipcode
  end

  def page
    @group_page    = Page.show_in_top_navigation.find_by(slug: params[:page_slug])
    @sub_nav_items = Page.show_in_sub_navigation(@group_page.group_name)

    @event_page = @group_page.event_pages.first
    @events = @event_page.events.page(params[:page])
  end

  def show
    @event = RegonlineEvent.displayable.sorted.find(params[:id])
  end

  def curriculum
    @group_page    = Page.show_in_top_navigation.find_by(slug: params[:page_slug])
    @sub_nav_items = Page.show_in_sub_navigation(@group_page.group_name)

    @event_page    = @group_page.event_pages.find_by(slug: params[:slug])
    @events        = @event_page.events.displayable.sorted.page(params[:page])

    filter_by_zipcode
  end

  def list
    @event_page = EventPage.find_by(slug: params[:slug])
    @events     = @event_page.events.displayable.sorted.page(params[:page])

    filter_by_zipcode
  end

  def trainings
    @event_trainings = EventTraining.all
  end

  private

  def filter_by_zipcode
    if params[:zipcode].present?
      @events = @events.near(params[:zipcode], 100)
    end
  end
end
