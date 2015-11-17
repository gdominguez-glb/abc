class Account::LicensesController < Account::BaseController
  before_action :authenticate_school_admin!
  before_action :set_emails_to_choose, only: [:index, :assign]

  def index
    @assign_licenses_form = AssignLicensesForm.new(total: 0)
  end

  def assign
    @assign_licenses_form = AssignLicensesForm.new(assign_licenses_params.merge(user: current_spree_user, licenses_ids: params[:licenses_ids].split(',')))
    if @assign_licenses_form.valid?
      @assign_licenses_form.perform
      flash[:success] = "Successully assigned licenses to recipients"
      redirect_to account_licenses_path(licenses_ids: params[:licenses_ids])
    else
      @assign_licenses_form.total = 0
      render :index
    end
  end

  def users
    @product_distributions = current_spree_user.product_distributions.where('quantity > 0').select('to_user_id, email').group('to_user_id, email').page(params[:page])
  end

  def export_users
    @emails = current_spree_user.product_distributions.pluck(:email).uniq
  end

  def user_stats
    @user = current_spree_user.to_users.find_by(id: params[:user_id])
  end

  def licenses_stats
    @licenses_ids = params[:licenses_ids].split(',')
    render layout: false
  end

  def edit_user_licenses
    @user = current_spree_user.to_users.find_by(id: params[:user_id])
    @product_distributions = Spree::ProductDistribution.where(from_user_id: current_spree_user.id, to_user_id: @user.id).where('quantity > 0').includes(:product)
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

  def cancel_invitation
    current_spree_user.product_distributions.where(to_user_id: nil, email: params[:email]).map{|pd| pd.revoke }
    redirect_to users_account_licenses_path
  end

  def select_users
    @emails = SelectUsersForm.new(licenses_recipients: params[:licenses_recipients], emails: params[:emails], users_file: params[:file]).perform
  end

  def revoke_all
    distribution = current_spree_user.product_distributions.find(params[:distribution_id])
    Spree::LicensesManager::DistributionRevoker.new(distribution).revoke
  end

  private

  def assign_licenses_params
    params.require(:assign_licenses_form).permit(:licenses_recipients, :licenses_number, :total, emails: [])
  end

  def set_emails_to_choose
    @emails = current_spree_user.product_distributions.pluck(:email).uniq
  end
end
