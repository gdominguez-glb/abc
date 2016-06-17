module EmailAssignment
  extend ActiveSupport::Concern

  module ClassMethods
    def assign_email_from_user(email_column, user_column)
      before_save -> {
        _user = self.send(user_column)
        _email = self.send(email_column)
        self.send("#{email_column}=", _user.try(:email)) if _user && _email.blank?
      }
    end

    def assign_user_from_email(user_column, email_column)
      before_save -> {
        _user = self.send(user_column)
        _email = self.send(email_column)
        self.send("#{user_column}_id=", Spree::User.find_by(email: email.downcase).try(:id)) if _email && _user.blank?
      }
    end
  end
end
