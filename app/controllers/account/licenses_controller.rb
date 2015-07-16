class Account::LicensesController < Account::BaseController
  before_action :authenticate_school_admin!

  def index
    @assign_licenses_form = AssignLicensesForm.new
  end

  def assign
    redirect_to account_licenses_path
  end

  def import_licenses
    if request.post?
      result = Spree::LicenseDistributer.new(current_spree_user, params[:file]).distribute
      if !result[:success]
        flash.now[:error] = result[:error]
      else
        redirect_to account_admin_path, notice: 'Assigned licenses successfully'
      end
    end
  end

  def distributions
    @distributions = current_spree_user.product_distributions.includes([:to_user, :product])
  end
end
