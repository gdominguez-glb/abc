class StaffsController < ApplicationController
  def index
    @staffs = Staff.displayable.order('position asc')
  end

  def trustees
    @staffs = Staff.displayable.order('position asc')
  end

  def show
    @staff = Staff.displayable.find(params[:id])
  end
end
