class TermsOfServiceController < ApplicationController

  skip_before_action :accepted_terms, only: [:display, :accept]

  def accept
    spree_current_user.update(accepted_terms: true, accepted_terms_2018: true, accepted_terms_2018_at: Time.now) unless spree_current_user.blank?
    redirect_to (session["spree_user_return_to"] || account_products_path)
  end

  def display
  end
end
