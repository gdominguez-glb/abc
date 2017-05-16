class NotificationTrigger < ActiveRecord::Base
  serialize :user_ids, Array
  serialize :product_ids, Array

  validates_presence_of :target_type, :content, :notify_at
  validates_presence_of :school_district_admin_user, if: ->(nt) { nt.school_district_target? }

  has_many :notifications, dependent: :destroy

  belongs_to :single_user, class_name: 'Spree::User'
  belongs_to :school_district_admin_user, class_name: 'Spree::User'
  belongs_to :curriculum
  belongs_to :product, class_name: 'Spree::Product'

  after_commit :send_notifications, on: :create

  TARGET_TYPES = [
    :single_user,
    :group_users,
    :school_district,
    :user_type,
    :every,
    :curriculum_users,
    :product,
    :products,
    :zip_codes,
    :sign_up_segments
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
    elsif self.user_type_target? && self.curriculum_id.present?
      self.user_type.present? ? Spree::User.with_curriculum(self.curriculum).where(title: self.user_type) : []
    elsif self.user_type_target?
      self.user_type.present? ? Spree::User.where(title: self.user_type) : []
    elsif self.every_target?
      Spree::User.where("1 = 1")
    elsif self.curriculum_users_target? && self.user_type.present?
      self.curriculum_id.present? ? Spree::User.with_curriculum(self.curriculum).where(title: self.user_type) : []
    elsif self.curriculum_users_target?
      self.curriculum_id.present? ? Spree::User.with_curriculum(self.curriculum) : []
    elsif self.product_target?
      find_product_target_users(self.product_id)
    elsif self.products_target?
      find_products_target_users(self.product_ids)
    elsif self.zip_codes_target?
      find_zip_codes_target_users(self.zip_codes)
    elsif self.sign_up_segments_target?
      find_segmented_users
    end
  end

  private

  def send_notifications
    NotificationWorker.perform_at(self.notify_at, self.id)
  end

  def find_product_target_users(product_id)
    return [] if product_id.blank?
    find_products_target_users([product_id])
  end

  def find_products_target_users(product_ids)
    return [] if product_ids.blank?
    user_ids = []
    products = Spree::Product.where(id: product_ids)
    bundles = Spree::Part.where(product_id: product_ids).map(&:bundle)
    products = [products, bundles].flatten.compact
    Spree::User.joins(:licensed_products).where(spree_licensed_products: { product_id: products.map(&:id) }).distinct
  end

  def find_zip_codes_target_users(zip_codes)
    users = Spree::User.where(zip_code: zip_codes.split(',').map(&:strip))
    users = users.where(title: self.user_type) if self.user_type.present?
    users = users.with_curriculum(self.curriculum) if self.curriculum_id.present?
    users
  end

  def find_segmented_users
    return [] if sign_up_started_at.blank? || sign_up_ended_at.blank?

    users = Spree::User.where("created_at >= ?", sign_up_started_at).where("created_at <= ?", sign_up_ended_at)
    users = users.where(title: self.user_type) if self.user_type.present?
    users = users.with_curriculum(self.curriculum) if self.curriculum_id.present?
    users
  end
end
