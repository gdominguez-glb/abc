class Account::LicensesController < Account::BaseController
  before_action :authenticate_school_admin!
  before_action :load_products, only: [:index, :assign]

  def index
    @assign_licenses_form = AssignLicensesForm.new(total: 0)
  end

  def assign
    @assign_licenses_form = AssignLicensesForm.new(assign_licenses_params.merge(user: current_spree_user))
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

  def distributions
    @distributions = current_spree_user.product_distributions.includes([:to_user, :product])
  end

  private

  def assign_licenses_params
    params.require(:assign_licenses_form).permit(:licenses_recipients, :product_id, :licenses_number, :total)
  end

  def load_products
    @products = current_spree_user.products
  end
end
