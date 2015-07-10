class EventsController < ApplicationController
  def index
    @events = RegonlineEvent.page(params[:page])
    if params[:zipcode].present?
      @events = @events.near(params[:zipcode], 100)
    end
  end
end
