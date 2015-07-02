class NotificationTrigger < ActiveRecord::Base
  serialize :user_ids, Array

  has_many :notifications

  TARGET_TYPES = [
    :single_user,
    :group_users,
    :school_district,
    :user_type,
    :every
  ]

  USER_TYPES = [
    :district_admin,
    :teacher,
    :parent
  ]
end
