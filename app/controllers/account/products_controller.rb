class Account::ProductsController < Account::BaseController
  def index
    @nav_name = 'My Resources'

    @my_products = filter_by_grade_taxon(current_spree_user.products).to_a.uniq(&:id)

    load_recent_activities
    load_recommendations
    load_notifications
    load_taxons
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
    @recommendations = Recommendation.limit(3)
    if current_spree_user.interested_subjects.present?
      @recommendations = @recommendations.where(subject: current_spree_user.interested_subjects)
    end
  end

  def load_notifications
    @notifications = current_spree_user.notifications.unread.limit(5)
  end

  def load_taxons
    @grade_taxons = Spree::Taxonomy.find_by(name: 'Grade').root.children rescue []
  end
end
