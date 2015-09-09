# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the
# db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if defined?(Spree::Core) && Spree::Country.count == 0
  Spree::Core::Engine.load_seed
end
# Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

if Spree::User.count == 0
  puts 'create admin user: web.admin@greatminds.net'
  school_district = SchoolDistrict.where(
    name: 'Test District', state_id: Spree::State.first.id).first_or_create(
    place_type: SchoolDistrict.place_types[:district],
    skip_salesforce_create: true)
  admin = Spree::User.new(
    first_name: 'Web',
    last_name: 'Admin',
    email: 'web.admin@greatminds.net',
    password: 'intridea4gm',
    password_confirmation: 'intridea4gm',
    school_district: school_district,
    skip_salesforce_create: true
  )
  role = Spree::Role.find_or_create_by(name: 'admin')
  admin.spree_roles << role
  admin.save
  admin.generate_spree_api_key!
end

if Spree::ShippingCategory.where(name: 'Digital Delivery').count == 0
  puts 'create digital delivery shipping category'
  Spree::ShippingCategory.create(name: 'Digital Delivery')
end

if Spree::ShippingMethod.count == 0
  puts 'create digital delivery shipping method'
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
  puts 'create payment methods'
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

if MediumPublication.count == 0
  {
    global: [
      { title: 'Press', slug: 'press',
        url: 'https://medium.com/great-minds-press' },
      { title: 'Reports', slug: 'reports',
        url: 'https://medium.com/great-minds-reports' }
    ],
    curriculum: [
      { title: 'Eureka Math', slug: 'eureka-math',
        url: 'https://medium.com/eureka-math', curriculum: 'math' },
      { title: 'Eureka Stories', slug: 'eureka-stories',
        url: 'https://medium.com/eureka-stories', curriculum: 'history' },
      { title: 'Great Minds English Blog', slug: 'english',
        url: 'https://medium.com/wheatley-blog', curriculum: 'english' }
    ]
  }.each do |blog_type, publications|
    publications.each do |publication|
      MediumPublication.create(
        title: publication[:title],
        url: publication[:url],
        blog_type: blog_type,
        slug: publication[:slug],
        page: Page.show_in_top_navigation.find_by(
          slug: publication[:curriculum]),
        display: true
      )
    end
  end
end

if Curriculum.count == 0
  %w(Math English History).each_with_index do |curriculum_name, index|
    Curriculum.create(name: curriculum_name, position: (index + 1),
                      visible: true)
  end
end

free_taxonomy = Spree::Taxonomy.find_or_create_by(name: 'Free?')
if free_taxonomy.taxons.count == 1
  root_free_taxon = free_taxonomy.taxons.first
  free_taxonomy.taxons.create(parent: root_free_taxon, name: 'Free')
  free_taxonomy.taxons.create(parent: root_free_taxon, name: 'Premium')
end

Spree::Taxonomy.find_or_create_by(name: 'Group')
