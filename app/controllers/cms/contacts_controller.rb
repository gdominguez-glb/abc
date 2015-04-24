class Cms::ContactsController < Cms::BaseController
  before_action :find_contact, except: [:index]

  def index
    @contacts = Contact.page(params[:page]).per(params[:per_page])
  end

  def edit
  end

  def update
    if @contact.update(contact_params)
      redirect_to cms_contacts_path, notice: 'Updated contact successfully!'
    else
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to cms_contacts_path, notice: 'Deleted contact successfully!'
  end

  private

  def find_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
