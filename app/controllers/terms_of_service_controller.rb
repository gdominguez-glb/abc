class TermsOfServiceController < ApplicationController

  skip_before_action :accepted_terms, only: [:display]

  def accept
    spree_current_user.update(:accepted_terms => true) unless spree_current_user.blank?
    redirect_to account_products_path
  end

  def display
  end
end
