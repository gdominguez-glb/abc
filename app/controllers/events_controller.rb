class EventsController < ApplicationController
  def index
    start_date = Date.today
    @current_month = start_date.month
    @date_range = start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week
  end
end
