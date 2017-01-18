class Account::ProductsController < Account::BaseController

  include ProductRedirectable
  before_action :set_product, only: [:launch]

  def index
    @nav_name = 'My Resources'

    @my_products = spree_current_user.my_resources.page(1).per(4)

    load_recommendations
    load_notifications
    load_whats_news
  end

  def shop_of_interest
    shops = current_spree_user.interested_shops
    redirect_to(shops.count == 1 ? shops.first.url : '/store')
  end

  def launch
    spree_current_user.update_log_activity_product(@product)
    launch_product(@product)
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
    @whats_news = load_dashboard_data(WhatsNew)
  end

  def load_dashboard_data(model)
    data = model.displayable_random.limit(3)
    if current_spree_user.send("#{model.table_name}_ids_to_exclude").present?
      data = data.where.not(id: current_spree_user.send("#{model.table_name}_ids_to_exclude"))
    end

    data = data.filter_by_subject_or_user_title_or_zip_code(current_spree_user.interested_curriculums, current_spree_user.title, current_spree_user.zip_code)
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
end
