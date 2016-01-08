class Account::TourController < Account::BaseController

  def dashboard
    current_spree_user.update(tour_showed_dashboard: true)
  end

  def licenses
    current_spree_user.update(tour_showed_licenses: true)
  end

  def licenses_users
    current_spree_user.update(tour_showed_licenses_users: true)
  end
end
