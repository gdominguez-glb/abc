class OpportunitiesController < ApplicationController

  def index
    @opportunity = Opportunity.new
  end

  def create
    @opportunity = Opportunity.new(opportunity_params)

    respond_to do |format|
      if @opportunity.save
        format.html { redirect_to opportunities_path, notice: "Opportunity was successfully created." }
        format.js
      else
        format.html { render :index, notice: "An error has occured, please try again." }
        format.js
      end
    end
  end

  private

  def opportunity_params
    params.require(:opportunity).permit(:salesforce_id, :skip_tax_exemption, attachments_attributes: [:file, :category])
  end
end
