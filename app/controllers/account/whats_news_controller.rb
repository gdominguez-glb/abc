class Account::WhatsNewsController < Account::BaseController
  def show
    whats_new = WhatsNew.find(params[:id])
    whats_new.increase_clicks!
    redirect_to whats_new.call_to_action_button_link
  end
end