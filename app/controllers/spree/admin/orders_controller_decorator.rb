Spree::Admin::OrdersController.class_eval do
  include AuthorizeAccountSales

  def index
    params[:q] ||= {}
    params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
    @show_only_completed = params[:q][:completed_at_not_null] == '1'
    params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
    params[:q][:completed_at_not_null] = '' unless @show_only_completed

    params[:q][:state_eq] ||= 'complete'

    # As date params are deleted if @show_only_completed, store
    # the original date so we can restore them into the params
    # after the search
    created_at_gt = params[:q][:created_at_gt]
    created_at_lt = params[:q][:created_at_lt]

    params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == "0"

    if params[:q][:created_at_gt].present?
      params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
    end

    if params[:q][:created_at_lt].present?
      params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
    end

    if @show_only_completed
      params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
      params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
    end

    @search = Spree::Order.includes(user: [:school_district]).accessible_by(current_ability, :index).ransack(params[:q])

    # lazyoading other models here (via includes) may result in an invalid query
    # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
    # see https://github.com/spree/spree/pull/3919
    @orders = @search.result(distinct: true).page(params[:page])
                                            .per(params[:per_page] ||
                Spree::Config[:admin_orders_per_page])

    # Restore dates
    params[:q][:created_at_gt] = created_at_gt
    params[:q][:created_at_lt] = created_at_lt
  end

  def edit
  end

  def change_licenses_owner_modal
    load_order
  end

  def change_licenses_owner
    load_order

    user = Spree::User.find_by(email: params[:new_owner_email])
    if @order.update(user: user, email: params[:new_owner_email])
      Spree::LicensesManager::OrderOwnerChanger.new(@order).execute
      flash[:notice] = 'Successfully changed licenses for order'
    else
      flash[:error] = 'Failed to change licenses for order'
    end
    redirect_to :back
  end
end
