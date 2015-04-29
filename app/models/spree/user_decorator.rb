Spree::User.class_eval do
  validates_presence_of :first_name, :last_name
end
