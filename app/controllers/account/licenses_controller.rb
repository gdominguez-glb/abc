class Account::LicensesController < Account::BaseController
  before_action :authenticate_school_admin!

  def index
    @assign_licenses_form = AssignLicensesForm.new(total: 0)
  end

  def assign
    @assign_licenses_form = AssignLicensesForm.new(assign_licenses_params.merge(user: current_spree_user, product_id: params[:product_id]))
    if @assign_licenses_form.valid?
      @assign_licenses_form.perform
      flash[:success] = "Successully assigned licenses to recipients"
      redirect_to account_licenses_path
    else
      render :index
    end
  end

  def import_modal
    @products = current_spree_user.products
  end

  def import
    result = Spree::LicenseDistributer.new({ user: current_spree_user, file: params[:file], product_id: params[:product_id] }).distribute
    if !result[:success]
      flash[:error] = result[:error]
      redirect_to account_licenses_path
    else
      redirect_to account_licenses_path, notice: 'Assigned licenses successfully'
    end
  end

  def users
    @product_distributions = current_spree_user.product_distributions.select('to_user_id, email').group('to_user_id, email').page(params[:page])
  end

  def user_stats
    @user = current_spree_user.to_users.find_by(id: params[:user_id])
  end

  def product_stats
    @product = current_spree_user.managed_products.find_by(id: params[:product_id])
    render layout: false
  end

  def edit_user_licenses
    @user = current_spree_user.to_users.find_by(id: params[:user_id])
    @product_distributions = Spree::ProductDistribution.where(to_user_id: @user.id).includes(:product)
  end

  def update_user_licenses
    updater = LicensesUpdater.new(product_distributions: params[:product_distributions], user: current_spree_user)
    if updater.valid?
      updater.perform
      @success = true
    else
      @error_full_messages = updater.errors.full_messages.join(' ')
    end
  end

  private

  def assign_licenses_params
    params.require(:assign_licenses_form).permit(:licenses_recipients, :licenses_number, :total)
  end
end
