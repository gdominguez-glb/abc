Spree::Role.class_eval do
  def self.admin
    Spree::Role.find_or_create_by(name: 'admin')
  end

  def self.user
    Spree::Role.find_or_create_by(name: 'user')
  end

  def self.school_admin
    Spree::Role.find_or_create_by(name: 'school admin')
  end

  def self.vanity_admin
    Spree::Role.find_or_create_by(name: 'vanity admin')
  end

  def self.csr
    Spree::Role.find_or_create_by(name: 'csr')
  end

  def self.hr
    Spree::Role.find_or_create_by(name: 'hr')
  end

  def self.pd
    Spree::Role.find_or_create_by(name: 'pd')
  end

  def self.account_sales
    Spree::Role.find_or_create_by(name: 'account_sales')
  end

  def is_internal?
    ['vanity admin', 'csr', 'hr', 'pd', 'account_sales', 'admin'].include?(self.name)
  end

  def self.roles_options
    [user, school_admin, vanity_admin, csr, hr, pd, account_sales, admin]
  end
end
