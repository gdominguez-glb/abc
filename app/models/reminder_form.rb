class ReminderForm
  include ActiveModel::Model

  RECIPIENT_OPTIONS = [
    "Those users who haven't accepted their invitation yet",
    "Those users who haven't logged in in the last 30 days"
  ]

  attr_accessor :from_user, :recipient

  def perform
    case @recipient
    when RECIPIENT_OPTIONS[0]
      send_invitation_remind
    when RECIPIENT_OPTIONS[1]
      send_login_remind
    end
  end

  def send_invitation_remind
    @from_user.product_distributions.where(to_user_id: nil).group_by(&:email).each do |email, distributions|
      ReminderMailer.invitation_remind(
        @from_user,
        email,
        distributions.map(&:product).map(&:name).uniq
      ).deliver_now
    end
  end

  def send_login_remind
    @from_user.to_users.where("last_sign_in_at < ?", 30.days.ago).pluck(:email).each do |email|
      ReminderMailer.login_remind(@from_user, email).deliver_now
    end
  end
end
