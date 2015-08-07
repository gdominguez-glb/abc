class Account::ProductsController < Account::BaseController
  def index
    @nav_name = 'My Products'

    @my_products = filter_by_grade_taxon(current_spree_user.products).to_a.uniq(&:id)
    @recent_activities = current_spree_user.activities.recent
    @recommendations   = Recommendation.limit(3)
    if current_spree_user.interested_subject.present?
      @recommendations = @recommendations.where(subject: current_spree_user.interested_subject)
    end

    @notifications = current_spree_user.notifications.unread.limit(5)

    @grade_taxons = Spree::Taxonomy.find_by(name: 'Grade').root.children rescue []
  end

  private

  def filter_by_grade_taxon(products)
    grade_taxon = Spree::Taxon.find_by(id: current_spree_user.grade_option)
    products    = products.in_taxons([grade_taxon]) if grade_taxon
    products
  end
end
