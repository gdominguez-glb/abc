class ContactController < ApplicationController

  def index
    @page_title = "Contact Us"
    default_topic = params[:topic].present? ? ContactForm::TOPICS[ (params[:topic].to_i) ] : nil
    @contact_form = ContactForm.new(school_district_type: 'School', topic: default_topic, country: 'United States')
  end

  def create
    @contact_form = ContactForm.new(contact_form_params.merge(referral: session[:utm], google_recaptcha_required: true, google_recaptcha: params["g-recaptcha-response"]))
    if @contact_form.valid?
      @contact_form.perform
      flash[:notice] = "Thanks for reaching out. We will be in touch shortly."
      redirect_to root_path
    else
      render :index
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(
      :topic, :support_type, :first_name, :last_name, :email, :phone, :role, :postal_code,
      :school_district_name, :school_district_type, :country, :state, :curriculum,
      :grade, :school_district_size, :title_1, :returning_customer, :tax_exempt,
      :tax_exempt_id, :desired_dates, :desired_training_topic, :desired_training_city,
      :items_purchased, :format, :description, :school_district, :training_groups_size,
      :interested_in_hosting_events, :related_grade_module_unit_lession, grade_bands: []
    )
  end
end
