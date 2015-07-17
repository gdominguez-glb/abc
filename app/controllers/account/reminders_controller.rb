class Account::RemindersController < Account::BaseController
  def new
    @reminder = ReminderForm.new(recipient: params[:email])
  end

  def create
    @reminder = ReminderForm.new(reminder_params.merge(from_user: current_spree_user))
    if @reminder.valid?
      @reminder.perform
      @success = true
    else
      @full_error_message = @reminder.errors.full_messages.join(" ")
    end
  end

  private

  def reminder_params
    params.require(:reminder_form).permit(:recipient, :content)
  end
end
