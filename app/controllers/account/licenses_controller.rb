class Account::LicensesController < Account::BaseController
  before_action :authenticate_school_admin!
  before_action :set_emails_to_choose, only: [:index, :assign]

  def index
    @assign_licenses_form = AssignLicensesForm.new(total: 0)
  end

  def assign
    @assign_licenses_form = AssignLicensesForm.new(assign_licenses_params.merge(user: current_spree_user))
    if @assign_licenses_form.valid?
      @assign_licenses_form.perform
      flash[:success] = "We're processing your licenses and will have them distributed shortly. To change licenses, use the USER MANAGEMENT tab below. Assign additional licenses by clicking SELECT PRODUCT below."
      redirect_to account_licenses_path
    else
      @assign_licenses_form.total = 0
      render :index
    end
  end

  def users
    @product_distributions = current_spree_user.product_distributions.where('quantity > 0').select('to_user_id, spree_product_distributions.email').group('to_user_id, spree_product_distributions.email')
    @product_distributions = @product_distributions
                                 .joins("left join spree_users on spree_product_distributions.to_user_id = spree_users.id")
                                 .group('first_name, last_name').order('first_name ASC, last_name ASC')
    if params[:query].present?
      @product_distributions = @product_distributions.
        where("spree_product_distributions.email ilike :query or spree_users.email ilike :query or spree_users.first_name ilike :query or spree_users.last_name ilike :query", query: "%#{params[:query].strip}%")
    end

    @product_distributions = @product_distributions.page(params[:page])
  end

  def export_users
    @emails = current_spree_user.product_distributions.pluck(:email).uniq
  end

  def user_stats
    @user = current_spree_user.to_users.find_by(id: params[:user_id])
  end

  def secondary_user_stats
    @from_user = current_spree_user.to_users.find_by(id: params[:user_id])
    @users = @from_user.to_users.where.not(spree_product_distributions: { to_user_id: @from_user.id })
  end

  def licenses_stats
    @licenses_ids = params[:licenses_ids]
    @licenses_ids = @licenses_ids.split(',') unless @licenses_ids.nil?
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
    current_spree_user.product_distributions.where(to_user_id: nil, email: params[:email]).each do |pd|
      Spree::LicensesManager::DistributionRevoker.new(pd).revoke
    end
    redirect_to users_account_licenses_path
  end

  def select_users
    @emails = SelectUsersForm.new(licenses_recipients: params[:licenses_recipients], emails: params[:emails], users_file: params[:file]).perform
  end

  def edit_select_users
    @emails = params[:emails].reject(&:blank?)
  end

  def revoke_all
    distribution = current_spree_user.product_distributions.find(params[:distribution_id])
    Spree::LicensesManager::DistributionRevoker.new(distribution).revoke
  end

  private

  def assign_licenses_params
    params.require(:assign_licenses_form).permit(:licenses_recipients, :licenses_number, :total, :licenses_ids, :emails => [])
  end

  def set_emails_to_choose
    @emails = current_spree_user.product_distributions.pluck(:email).uniq
  end
end
