class Account::ProductsController < Account::BaseController
  def index
    @nav_name = 'My Products'

    @my_products = filter_by_grade_taxon(current_spree_user.products).to_a.uniq(&:id)
    @recent_activities = current_spree_user.activities.recent
    @recommendations   = Recommendation.where(subject: current_spree_user.interested_subject).limit(3)

    @notifications = current_spree_user.notifications.unread.limit(5)

    @grade_taxons = Spree::Taxonomy.find_by(name: 'Grade').root.children rescue []
  end

  def update
    current_spree_user.settings[:grade_option] = params[:grade_taxon_id]

    @my_products = filter_by_grade_taxon(current_spree_user.products).to_a.uniq(&:id)
  end

  private

  def filter_by_grade_taxon(products)
    grade_taxon = Spree::Taxon.find_by(id: current_spree_user.grade_option)
    products    = products.in_taxons([grade_taxon]) if grade_taxon
    products
  end
end
