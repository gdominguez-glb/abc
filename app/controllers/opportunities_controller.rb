class OpportunitiesController < ApplicationController

  def index
    @opportunity = Opportunity.new
  end

  def create
    @opportunity = Opportunity.new(opportunity_params)

    respond_to do |format|
      if @opportunity.save
        format.html { redirect_to opportunities_path, notice: "Thank you for submitting your purchase order! A member of our Order Processing team will process your submission shortly. If you have any questions or concerns, please feel free to contact Great Minds at 202-223-1854." }
        format.js
      else
        format.html { render :index, notice: "An error has occured, please try again." }
        format.js
      end
    end
  end

  private

  def opportunity_params
    params.require(:opportunity).permit(:salesforce_id, :po_number, :name, :email, :phone_number, :skip_tax_exemption, attachments_attributes: [:file, :category])
  end
end
