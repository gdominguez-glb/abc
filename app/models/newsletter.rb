require 'mailchimp'

class Newsletter
  include ActiveModel::Model

  attr_accessor :email, :first_name, :last_name, :lists, :user

  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates_presence_of :first_name, :last_name
  validate :must_select_lists

  def set_attribtues_from_user(user)
    @first_name = user.first_name
    @last_name  = user.last_name
    @email      = user.email

    @lists = Mailchimp.list_ids_by_role(user)
  end

  def perform
    @lists.each do |list_id|
      Mailchimp.delay.subscribe(list_id, {
        email: @email,
        first_name: @first_name,
        last_name: @last_name
      })
    end
  end

  def must_select_lists
    if (self.lists || []).blank?
      self.errors.add(:lists, 'must be selected at least once.')
    end
  end
end
