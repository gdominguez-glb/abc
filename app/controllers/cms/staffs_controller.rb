class Cms::StaffsController < Cms::BaseController
  skip_before_action :authenticate_admin_in_cms!
  before_action :authenticate_hr_admin_in_cms!

  before_action :find_staff, except: [:index, :new, :create, :update_positions, :trustees, :emeritus_advisors, :pbc_board]

  def index
    @staffs = Staff.staff.order('position asc')
  end

  def trustees
    @staffs = Staff.trustee.order('position asc')
  end

  def emeritus_advisors
    @staffs = Staff.emeritus_advisor.order('position asc')
  end

  def pbc_board
    @staffs = Staff.pbc_board.order('position asc')
  end
  
  def new
    @staff = Staff.new
    if params[:state] == 'trustees'
      @staff.staff_type = :trustee
    end
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
    case params[:scope]
    when 'trustees'
      staffs = Staff.trustee
    when 'staffs'
      staffs = Staff.staff
    when 'emeritus_advisors'
      staffs = Staff.emeritus_advisor
    when 'pbc_board'
      staffs = Staff.pbc_board
    end

    update_positions_with_klass(staffs)
    render body: nil
  end

  private

  def find_staff
    @staff = Staff.find(params[:id])
  end

  def staff_params
    params.require(:staff).permit(:name, :title, :description, :display, :picture, :staff_type)
  end
end
