class TeamController < ApplicationController
  def index
    @page_title = 'Team'
    @staffs = Staff.displayable.staff.order('position asc')
  end

  def trustees
    @page_title = 'Trustees'
    @trustees = Staff.displayable.trustee.order('position asc')
  end

  def show
    @staff = Staff.displayable.find(params[:id])
    @page_title = "Staff - #{@staff.name}"
  end
end
