require 'rails_helper'

describe 'User view license distribution' do
  it 'should view the whole licenses from the district', js: true do
    create_users
    create_distributions

    visit 'resources/login'
    page.fill_in 'Email', with: @admin.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    visit users_account_licenses_path

    expect(page.all('table tbody tr').count).to eq(2)

    click_on 'Logout'

    visit 'resources/login'
    page.fill_in 'Email', with: @first_distributor.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    visit users_account_licenses_path

    expect(page.all('table tbody tr').count).to eq(2)

    click_on 'Logout'

    visit 'resources/login'
    page.fill_in 'Email', with: @second_distributor.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    visit users_account_licenses_path

    expect(page.all('table tbody tr').count).to eq(2)

    click_on 'Logout'
  end

  def create_users
    @admin = create :gm_user,
                    email: 'example1@example.com'
    @admin.spree_roles << Spree::Role.find_or_create_by(name: 'school admin')
    @admin.save

    country = Spree::Country.find_by(iso: 'US')
    country.update name: 'United States'

    state = Spree::Country.find_by(iso: 'US').states.first
    state.update name: 'New York'

    school_district = create :school_district, name: 'District 9',
                             country: country,
                             state: state,
                             city: 'San Francisco',
                             place_type: SchoolDistrict.place_types[:district]

    @admin.school_district = school_district
    @admin.save

    @first_distributor = create :gm_user,
                               email: 'example2@example.com',
                               school_district: school_district
    @first_distributor.spree_roles << Spree::Role.find_or_create_by(name: 'school admin')
    @first_distributor.save

    @second_distributor = create :gm_user,
                                email: 'example3@example.com',
                                school_district: school_district
    @second_distributor.spree_roles << Spree::Role.find_or_create_by(name: 'school admin')
    @second_distributor.save
  end

  def create_distributions
    product = create :product
    licensed_product = create :spree_licensed_product,
                       user: @admin,
                       product: product

    create :spree_product_distribution,
           licensed_product: licensed_product,
           product: product,
           from_user: @admin,
           to_user: @first_distributor

    create :spree_product_distribution,
           licensed_product: licensed_product,
           product: product,
           from_user: @admin,
           to_user: @second_distributor
  end
end
