class Account::TourController < Account::BaseController

  def start
    current_spree_user.update(tour_showed: true)
  end
end
