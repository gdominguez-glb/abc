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
end
