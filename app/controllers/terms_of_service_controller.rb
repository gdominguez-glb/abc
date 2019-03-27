class TermsOfServiceController < ApplicationController
  skip_before_action :accepted_terms, only: [:display, :accept]

  def accept
    spree_current_user.accept_terms! unless spree_current_user.blank?
    redirect_to (session["spree_user_return_to"] || account_products_path)
  end

  def display
  end
end
