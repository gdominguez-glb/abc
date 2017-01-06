class Account::ProductsController < Account::BaseController
  def index
    @nav_name = 'My Resources'

    @my_products = filter_by_grade_taxon(current_spree_user.products_in_dashboard).to_a.uniq(&:id)

    load_recommendations
    load_notifications
    load_whats_news
  end

  def shop_of_interest
    shops = current_spree_user.interested_shops
    redirect_to(shops.count == 1 ? shops.first.url : '/store')
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
    if current_spree_user.ids_to_exclude(model).present?
      data = data.where.not(id: current_spree_user.ids_to_exclude(model))
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
end
