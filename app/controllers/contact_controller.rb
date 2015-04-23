class ContactController < ApplicationController
  def index
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to contact_path, notice: "Contact submit successfully!"
    else
      render :index
    end
  end

  private
    
  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
