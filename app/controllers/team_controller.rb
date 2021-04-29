class TeamController < ApplicationController
  def index
    @page_title = 'Leadership Team'
    @staffs = Staff.displayable.staff.order('position asc')
  end

  def trustees
    @page_title = 'Trustees & Advisors'
    @trustees = Staff.displayable.trustee.order('position asc')
    @emeritus_advisors = Staff.displayable.emeritus_advisor.order('position asc')
  end

  def directors
    @page_title = 'BOARD OF DIRECTORS'
    @pbc_board = Staff.displayable.pbc_board.order('position asc')
  end

  def show
    @staff = Staff.displayable.find(params[:id])
    @page_title = "Staff - #{@staff.name}"
  end
end
