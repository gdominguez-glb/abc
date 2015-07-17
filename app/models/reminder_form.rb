class ReminderForm
  include ActiveModel::Model

  attr_accessor :recipient, :content
end
