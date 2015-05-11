Spree::User.class_eval do
  validates_presence_of :first_name, :last_name, :school_district

  # add any other characters you'd like to disallow inside the [ brackets ]
  # metacharacters [, \, ^, $, ., |, ?, *, +, (, and ) need to be escaped with a \
  validates_format_of :first_name, :last_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/

  belongs_to :school_district

  has_many :completed_orders, ->{ where.not(completed_at: nil) }, class_name: 'Spree::Order'
  has_many :products, through: :completed_orders, class_name: 'Spree::Product'
  has_many :favorite_products, class_name: 'Spree::FavoriteProduct'

  accepts_nested_attributes_for :school_district, reject_if: proc { |attributes| attributes['name'].blank? }

  before_create :assign_user_role

  def assign_user_role
    if spree_roles.empty?
      spree_roles << Spree::Role.user
    end
  end

  def assign_school_admin_role
    if !has_school_admin_role?
      spree_roles << Spree::Role.school_admin
    end
  end

  def has_school_admin_role?
    spree_roles.where(id: Spree::Role.school_admin.id).count > 0
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name=(new_name)
    self.first_name = new_name.split(' ').first
    self.last_name = new_name.split(' ').last
  end
end
