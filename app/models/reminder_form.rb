class ReminderForm
  include ActiveModel::Model

  attr_accessor :from_user, :recipient, :content

  validates_presence_of :content
  validates :recipient, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def perform
    ReminderMailer.remind(@from_user, @recipient, @content).deliver
  end
end
