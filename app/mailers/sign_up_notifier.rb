class SignUpNotifier
  def self.notify(user_id)
    user = Spree::User.find(user_id)
    MandrillSender.new.deliver_with_template('sign-up-email', user.email, 'Your Great Minds Account', {})
  end
end
