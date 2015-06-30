class Account::AdminController < Account::BaseController
  before_action :authenticate_school_admin!

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
end
