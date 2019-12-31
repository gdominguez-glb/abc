require 'rails_helper'

describe 'Checkout' do
  before :each do
    user = create :gm_user

    visit 'resources/login'
    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'should show termns and conditions' do
    product = create :product, name: 'test product', slug: 'test-product',
                               price: 100,
                               license_text: 'this is a license test',
                               license_length: 100

    visit "/resources/products/#{product.slug}"
    click_button 'Add To Cart'

    click_button 'Checkout'
    click_button 'Save and Continue'

    list = page.find '#checkout-step-terms_and_conditions'

    expect(page).to have_content 'this is a license test'
    expect(page).to have_content 'I accept the Terms and Conditions.'
    expect(list).to have_content 'Terms'
  end

  it 'should show termns and conditions for more than one product' do
    first_product = create :product, name: 'test product', slug: 'test-product',
                                     price: 100,
                                     license_text: 'this is a license test',
                                     license_length: 100
    second_product = create :product, name: 'test product 2',
                                      slug: 'test-product-2',
                                      price: 150,
                                      license_text: 'this is a license test for second product',
                                      license_length: 110

    visit "/resources/products/#{first_product.slug}"
    click_button 'Add To Cart'

    visit "/resources/products/#{second_product.slug}"
    click_button 'Add To Cart'

    click_button 'Checkout'
    click_button 'Save and Continue'

    list = page.find '#checkout-step-terms_and_conditions'

    expect(page).to have_content 'this is a license test'
    expect(page).to have_content 'this is a license test for second product'
    expect(page).to have_content 'I accept the Terms and Conditions.'
    expect(list).to have_content 'Terms'
  end

  it 'should not show termns and conditions' do
    product = create :product, name: 'test product', slug: 'test-product',
                               price: 100

    visit "/resources/products/#{product.slug}"
    click_button 'Add To Cart'

    click_button 'Checkout'
    click_button 'Save and Continue'

    expect(page).not_to have_content 'Terms and Conditions'
  end
end
