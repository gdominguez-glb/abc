class NotificationTrigger < ActiveRecord::Base
  serialize :user_ids, Array

  validates_presence_of :target_type, :content, :notify_at
  validates_presence_of :school_district_admin_user, if: ->(nt) { nt.school_district_target? }

  has_many :notifications, dependent: :destroy

  belongs_to :single_user, class_name: 'Spree::User'
  belongs_to :school_district_admin_user, class_name: 'Spree::User'
  belongs_to :curriculum
  belongs_to :product, class_name: 'Spree::Product'

  after_create :send_notifications

  TARGET_TYPES = [
    :single_user,
    :group_users,
    :school_district,
    :user_type,
    :every,
    :curriculum_users,
    :product,
    :zip_codes
  ]

  TARGET_TYPES.each do |target_type|
    define_method("#{target_type}_target?") do
      self.target_type == target_type.to_s
    end
  end

  def group_users
    Spree::User.where(id: self.user_ids)
  end

  def deliver!
    update(status: 'delivered')
  end

  def calculate_target_users
    if self.single_user_target?
      [self.single_user]
    elsif self.school_district_target?
      [self.school_district_admin_user.to_users]
    elsif self.group_users_target?
      self.group_users
    elsif self.user_type_target?
      Spree::User.send("with_#{self.user_type.downcase}_title")
    elsif self.every_target?
      Spree::User.where("1 = 1")
    elsif self.curriculum_users_target?
      Spree::User.with_curriculum(self.curriculum)
    elsif self.product_target?
      find_product_target_users(self.product_id)
    elsif self.zip_codes_target?
      find_zip_codes_target_users(self.zip_codes)
    end
  end

  private

  def send_notifications
    NotificationWorker.perform_at(self.notify_at, self.id)
  end

  def find_product_target_users(product_id)
    return [] if product_id.blank?
    user_ids = []
    product = Spree::Product.find(product_id)
    bundles = Spree::Part.where(product_id: product_id).map(&:bundle)
    products = [product, bundles].flatten.compact
    Spree::User.joins(:licensed_products).where(spree_licensed_products: { product_id: products.map(&:id) })
  end

  def find_zip_codes_target_users(zip_codes)
    Spree::User.where(zip_code: zip_codes.split(',').map(&:strip))
  end
end
