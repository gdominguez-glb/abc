Spree::Admin::UsersController.class_eval do

  def collection
    return @collection if @collection.present?
    if request.xhr? && params[:q].present?
      @collection = ajax_collection_result
    else
      if params[:q].present? && params[:q].is_a?(Hash)
        params[:q].each { |k, v| v.strip! }
      end
      @search = Spree.user_class.ransack(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
    end
  end

  def ajax_collection_result
    Spree.user_class.includes(:bill_address, :ship_address).
      where("spree_users.email #{LIKE} :search
                                     OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                     OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                     OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)
                                     OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)",
                                     { :search => "#{params[:q].strip}%" }).limit(params[:limit] || 100)
  end
end
