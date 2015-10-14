class StaffsController < ApplicationController
  def index
    @staffs = Staff.displayable.staff.order('position asc')
  end

  def trustees
    @trustees = Staff.displayable.trustee.order('position asc')
  end

  def show
    @staff = Staff.displayable.find(params[:id])
  end
end
