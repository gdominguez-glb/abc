class Account::ProductsController < Account::BaseController
  def index
    @nav_name = 'My Resources'

    @my_products = filter_by_grade_taxon(current_spree_user.products_in_dashboard).to_a.uniq(&:id)

    load_recommendations
    load_notifications
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
    @recommendations = Recommendation.displayable_random.limit(3)
    if current_spree_user.recommendation_ids_to_exclude.present?
      @recommendations = @recommendations.where.not(id: current_spree_user.recommendation_ids_to_exclude)
    end
    @recommendations = @recommendations.filter_by_subject_or_user_title(current_spree_user.interested_curriculums, current_spree_user.title)
    @recommendations.each do |recommendation|
      recommendation.increase_views!
    end
  end

  def load_notifications
    @notifications = current_spree_user.notifications.unread.unexpire.limit(5)
    @notifications.each do |notification|
      notification.mark_as_viewed!
    end
  end

  def load_taxons
    @grade_taxons = Spree::Taxonomy.find_by(name: 'Grade').root.children rescue []
  end
end
