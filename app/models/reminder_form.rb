class ReminderForm
  include ActiveModel::Model

  RECIPIENT_OPTIONS = [
    'All Users',
    "Those users who haven't accepted their invitation yet",
    "Those users who haven't logged in in the last 30 days"
  ]

  attr_accessor :from_user, :recipient, :content

  validates_presence_of :content

  def perform
    recipient_emails.each do |email|
      ReminderMailer.remind(@from_user, email, @content).deliver
    end
  end

  def recipient_emails
    @emails ||= begin
      case @recipient
      when RECIPIENT_OPTIONS[0]
        @from_user.to_users.pluck(:email)
      when RECIPIENT_OPTIONS[1]
        @from_user.product_distributions.where(user_id: nil).pluck(:email)
      when RECIPIENT_OPTIONS[2]
        @from_user.to_users.where("last_sign_in_at < ?", 30.days.ago).pluck(:email)
      end
    end
  end
end
