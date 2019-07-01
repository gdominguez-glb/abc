class DomainsController < ApplicationController
  before_action :set_domain, only: [:destroy]

  def create
    school_district = current_spree_user.school_district
    product = Spree::Product.find domain_params[:product]
    @domain = Domain.new name: domain_params[:name],
                        school_district: school_district,
                        product: product
    if @domain.save
      redirect_to domains_account_licenses_path
    else
      redirect_to domains_account_licenses_path, flash: { error: @domain.errors.full_messages.join('<br>').html_safe }
    end
  end

  def destroy
    @domain.destroy

    redirect_to domains_account_licenses_path
  end

  private

  def domain_params
    params.require(:domain).permit(:name, :product)
  end

  def set_domain
    @domain = Domain.find(params[:id])
  end
end
