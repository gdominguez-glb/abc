class ContactController < ApplicationController

  def index
    @contact_form = ContactForm.new(school_district_type: 'School')
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)
    if @contact_form.valid?
      @contact_form.perform
      flash[:notice] = "Successfully submited contact info."
      redirect_to contact_path
    else
      render :index
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:topic, :support_type, :first_name, :last_name, :email, :phone, :role, :school_district_name, :school_district_type,
    :country, :state, :curriculum, :grade, :school_district_size, :title_1, :returning_customer, :tax_exempt, :tax_exempt_id, :desired_dates,
    :desired_training_topic, :items_purchased, :format, :description, :school_district)
  end
end
