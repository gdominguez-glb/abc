class ContactController < ApplicationController

  def index
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(contact_form_params)
    if @contact_form.valid?
      redirect_to contact_path
    else
      render :index
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit!
  end
end
