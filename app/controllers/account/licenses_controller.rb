class Account::LicensesController < Account::BaseController
  before_action :authenticate_school_admin!

  def index
    @assign_licenses_form = AssignLicensesForm.new(total: 0)
    load_products
  end

  def assign
    @assign_licenses_form = AssignLicensesForm.new(assign_licenses_params.merge(user: current_spree_user))
    load_products
    if @assign_licenses_form.valid?
      @assign_licenses_form.perform
      flash[:notice] = "Successully assigned licenses to recipients"
      redirect_to account_licenses_path
    else
      render :index
    end
  end

  def import
    result = Spree::LicenseDistributer.new(current_spree_user, params[:file]).distribute
    if !result[:success]
      flash[:error] = result[:error]
    else
      redirect_to account_licenses_path, notice: 'Assigned licenses successfully'
    end
  end

  def users
    @users = current_spree_user.to_users.includes(:school_district, :products).page(params[:page])
  end

  def distributions
    @distributions = current_spree_user.product_distributions.includes([:to_user, :product])
  end

  def reassign_modal
    @from_user = find_from_user
    if @from_user
      @assign_licenses_form = AssignLicensesForm.new()
      load_products(@from_user)
    end
  end

  def reassign
    @from_user = find_from_user
    if @from_user
      @reassign_licenses_form = ReassignLicensesForm.new(assign_licenses_params.merge(user: @from_user))
      if @reassign_licenses_form.valid?
        @reassign_licenses_form.perform
        @success = true
      else
        @error_full_messages = @reassign_licenses_form.errors.full_messages.join(', ')
      end
    else
      @error_full_messages = "Invalid user"
    end
  end

  private

  def assign_licenses_params
    params.require(:assign_licenses_form).permit(:licenses_recipients, :product_id, :licenses_number, :total)
  end

  def load_products(user=current_spree_user)
    @products = user.products
  end

  def find_from_user
    current_spree_user.to_users.find(params[:from_user_id])
  end
end
