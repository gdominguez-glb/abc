# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Spree::Core::Engine.load_seed if defined?(Spree::Core)
# Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

if Spree::User.count == 0
  puts "create admin user: web.admin@greatminds.net"
  school_district = SchoolDistrict.find_or_create_by(name: 'Test District', state_id: Spree::State.first.id)
  admin = Spree::User.new(
    first_name: 'Web',
    last_name: 'Admin',
    email: 'web.admin@greatminds.net',
    password: 'intridea4gm',
    password_confirmation: 'intridea4gm',
    school_district: school_district
  )
  role = Spree::Role.find_or_create_by(name: 'admin')
  admin.spree_roles << role
  admin.save
  admin.generate_spree_api_key!
end

if Spree::ShippingCategory.where(name: 'Digital Delivery').count == 0
  puts "create digital delivery shipping category"
  Spree::ShippingCategory.create(name: 'Digital Delivery')
end

if Spree::ShippingMethod.count == 0
  puts "create digital delivery shipping method"
  shipping_category = Spree::ShippingCategory.find_by(name: 'Digital Delivery')
  Spree::ShippingMethod.create(
    name: 'Digital Delivery',
    display_on: '',
    zones: Spree::Zone.all,
    shipping_categories: [shipping_category],
    calculator_type: 'Spree::Calculator::Shipping::DigitalDelivery'
  )
end

if Spree::PaymentMethod.count == 0
  puts "create payment methods"
  Spree::PaymentMethod.create(
    name: 'Credit Card',
    type: 'Spree::Gateway::StripeGateway'
  )
  Spree::PaymentMethod.create(
    name: 'Check',
    type: 'Spree::PaymentMethod::Check'
  )
  Spree::PaymentMethod.create(
    name: 'Purchase Order',
    type: 'Spree::PaymentMethod::PurchaseOrder'
  )
end
