class Account::RemindersController < Account::BaseController
  def new
    @reminder = ReminderForm.new
  end

  def create
  end
end
