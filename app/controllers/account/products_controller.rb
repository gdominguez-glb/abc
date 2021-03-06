class Account::ProductsController < Account::BaseController

  include ProductRedirectable
  before_action :set_product, only: [:launch]
  before_action :set_curriculum, only: [:index]
  before_action :set_visited_times, only: [:index]

  def index
    @nav_name = 'My Resources'

    @pinned_products = spree_current_user.pinned_products.map(&:product).select{|product| spree_current_user.accessible_products.include?(product) }
    @my_products     = spree_current_user.my_resources.page(1).per(4)
    @my_products     = filter_by_curriculum(@my_products, @curriculum) unless @curriculum.nil?

    load_recommendations
    load_notifications
    load_whats_news
  end

  def shop_of_interest
    shops = current_spree_user.interested_shops
    redirect_to(shops.count == 1 ? shops.first.url : '/resources')
  end

  def launch
    spree_current_user.update_log_activity_product(@product)
    launch_product(@product)
  end

  def remove_free_product_modal
    @product = Spree::Product.find(params[:id])
  end

  def remove_free_product
    @product = Spree::Product.find(params[:id])
    Spree::LicensesManager::DeleteFreeProduct.new(current_spree_user, @product).delete!
  end

  def pin_product_modal
    @product = Spree::Product.find(params[:id])
  end

  def pin_product
    if spree_current_user.pinned_products.count < 3
      product = Spree::Product.find(params[:id])
      spree_current_user.pin_product(product)
    else
      flash[:notice] = "You can not pin more than 3 resources to your dashboard."
    end

    redirect_to account_products_path
  end

  def unpin_product_modal
    @product = Spree::Product.find(params[:id])
  end

  def unpin_product
    product = Spree::Product.find(params[:id])
    spree_current_user.unpin_product(product)

    redirect_to account_products_path
  end

  private

  def filter_by_grade_taxon(products)
    grade_taxon = Spree::Taxon.find_by(id: current_spree_user.grade_option)
    products    = products.in_taxons([grade_taxon]) if grade_taxon
    products
  end

  def load_recent_activities
    @recent_activities = current_spree_user.activities.recent
  end

  def load_recommendations
    @recommendations = load_dashboard_data(Recommendation)
  end

  def load_whats_news
    @whats_news = load_dashboard_data(WhatsNew, {limit: 2})
  end

  def load_dashboard_data(model, options = {})
    options[:limit] ||= 3
    data = model.displayable_random.limit(options[:limit])
    if current_spree_user.send("#{model.table_name}_ids_to_exclude").present?
      data = data.where.not(id: current_spree_user.send("#{model.table_name}_ids_to_exclude"))
    end

    data = data.filter_by_subject_or_user_title_or_zip_code(current_spree_user.interested_curriculums, current_spree_user.title, current_spree_user.zip_code)
    data = data.unexpired if model == Recommendation

    data.each{ |d| d.increase_views! }
    data
  end

  def load_notifications
    @notifications = current_spree_user.notifications.unread.unexpire.limit(5)
    @notifications.each { |notification| notification.mark_as_viewed! }
  end

  def load_taxons
    @grade_taxons = Spree::Taxonomy.find_by(name: 'Grade').root.children rescue []
  end

  def set_product
    @product = Spree::Product.find(params[:id])
  end

  def set_curriculum
    @curriculum = Curriculum.find_by(id: params.try(:[], :curriculum_id))
  end

  def filter_by_curriculum(products, curriculum)
    products = products.where(curriculum_id: curriculum.id)
  end

  def set_visited_times
    session[:visited_times] ||= 0
    session[:visited_times] += 1
  end
end
