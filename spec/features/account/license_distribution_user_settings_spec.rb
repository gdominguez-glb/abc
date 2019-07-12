require 'rails_helper'
require 'sidekiq/testing'

describe 'License distribution on user settings page' do
  before(:each) do
    @admin = create :gm_user, email: 'example1@example.com'
    @admin.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    @admin.save

    state = Spree::Country.find_by(iso: 'US').states.first
    state.update name: 'New York'

    country = Spree::Country.find_by(iso: 'US')
    country.update name: 'United States'

    @district = create :school_district, name: 'Colegio Motolinia',
                       country: @country,
                       state: state

  end

  it 'should receive license of a product that have a domain and automatic distribution enabled', js: true do
    user = create :gm_user, email: 'example2@example.com'

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    product = create :product, name: 'Eureka Navigator LTI', product_type: 'library'
    product2 = create :product, name: 'Wit and Wisdom', product_type: 'library'
    domain = create :domain, name: 'example.com', product: product, school_district: @district
    domain2 = create :domain, name: 'example.com', product: product2, school_district: @district
    create :spree_licensed_product,
           user: @admin,
           quantity: 10,
           product: product
    create :spree_licensed_product,
           user: @admin,
           quantity: 5,
           product: product2

    visit 'account/settings'

    uncheck 'spree_user_automatic_distribution'

    click_on 'Save'

    select2 'EUREKA NAVIGATOR LTI', css: '#s2id_spree_user_licenses'

    click_on 'Save'

    LicensesDistributionWorker.drain

    create(:activity, item: product, user: user, action: 'buy')

    visit 'account/resources'

    expect(page).to have_text('EUREKA NAVIGATOR LTI')
  end

  it 'should fail if the user admin doesn\'t have a license distribution available', js: true do
    user = create :gm_user, email: 'example2@example.com'

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    product = create :product, name: 'Eureka Navigator LTI', product_type: 'library'
    product2 = create :product, name: 'Wit and Wisdom', product_type: 'library'
    domain = create :domain, name: 'example.com', product: product, school_district: @district
    domain2 = create :domain, name: 'example.com', product: product2, school_district: @district
    create :spree_licensed_product,
           user: @admin,
           quantity: 0,
           product: product
    create :spree_licensed_product,
           user: @admin,
           quantity: 0,
           product: product2

    visit 'account/settings'

    expect(page).not_to have_text('Mark this checkbox if you are not interested on receiving a license by automatic distribution.')
  end
end
