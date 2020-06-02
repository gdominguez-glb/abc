# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe 'Admin License Management' do
  it 'should not display the licenses if it is not assigned', js: true do
    create_distributions(false)
    visit 'resources/login'

    page.fill_in 'Email', with: @second_user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    visit '/account/products'
    expect(page).to have_text('YOU HAVE 0 RESOURCES')
  end

  it 'should display the licenses if it is get assigned', js: true do
    create_distributions
    visit 'resources/login'

    page.fill_in 'Email', with: @user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    visit '/account/licenses'

    page.execute_script("$('#assign_licenses_form_licenses_ids').val(1);")
    page.execute_script(
      "$('#assign_licenses_form_licenses_recipients')." \
      "val('example2@example.com');"
    )
    page.fill_in 'assign_licenses_form_licenses_number', with: 10
    click_button('Assign License(s)')
    expect(page).to have_text(
      "We're processing your licenses" \
      'and will have them distributed' \
      'shortly. To change licenses, use?' \
      'the USER MANAGEMENT tab below.' \
      'Assign additional licenses by clicking SELECT PRODUCT below.'
    )

    visit 'resources/logout'

    visit 'resources/login'

    page.fill_in 'Email', with: @second_user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    visit '/account/products'
    expect(page).to have_text('YOU HAVE 0 RESOURCES')
  end

  def create_distributions(can_distibuted = true)
    @user = create(:gm_user, email: 'example1@example.com')
    @user.spree_roles << Spree::Role.find_or_create_by(name: 'school admin')
    @user.save

    @second_user = create :gm_user, email: 'example2@example.com',
                                    first_name: 'Bruce',
                                    last_name: 'Wayne'

    product =
      create(
        :product,
        name: 'Eureka Navigator LTI',
        product_type: 'library',
        show_in_storefront: true,
        individual_sale: true,
        for_sale: true,
        available_on: 1.days.ago
      )

    product2 = create :product, name: 'Wit and Wisdom', product_type: 'library'

    licensed_product1 =
      create :spree_licensed_product,
             user: @user,
             product: product,
             quantity: 10,
             can_be_distributed: can_distibuted

    create :spree_licensed_product,
           user: @user,
           product: product2,
           quantity: 10,
           can_be_distributed: can_distibuted

    create :spree_product_distribution,
           licensed_product: licensed_product1,
           product: product,
           from_user: @user,
           to_user: @second_user,
           quantity: 10

    create(:activity, item: product, user: @user, action: 'buy')
    create(:activity, item: product2, user: @user, action: 'buy')
    create(:activity, item: product, user: @second_user, action: 'buy')
  end
end
