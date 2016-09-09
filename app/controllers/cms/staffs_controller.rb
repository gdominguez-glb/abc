class Cms::StaffsController < Cms::BaseController
  skip_before_action :authenticate_admin_in_cms!
  before_action :authenticate_hr_admin_in_cms!

  before_action :find_staff, except: [:index, :new, :create, :update_positions]

  def index
    @staffs = Staff.order('position asc')
  end

  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params)
    if @staff.save
      redirect_to cms_staffs_path, notice: 'Created staff successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @staff.update(staff_params)
      redirect_to cms_staffs_path, notice: 'Updated staff successfully!'
    else
      render :edit
    end
  end

  def destroy
    @staff.destroy
    redirect_to cms_staffs_path, notice: 'Deleted staff successfully!'
  end

  def update_positions
    update_positions_with_klass(Staff)
    render nothing: true
  end

  private

  def find_staff
    @staff = Staff.find(params[:id])
  end

  def staff_params
    params.require(:staff).permit(:name, :title, :description, :display, :picture, :staff_type)
  end
end
