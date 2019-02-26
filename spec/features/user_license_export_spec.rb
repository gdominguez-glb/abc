require 'rails_helper'

describe 'Export user licenses' do
  it 'should export csv fie with a list of user licenses' do
    first_user = create :gm_user, email: 'example1@example.com'
    first_user.spree_roles << Spree::Role.find_or_create_by(name: 'school admin')
    first_user.save

    second_user = create :gm_user, email: 'example2@example.com'
    third_user = create :gm_user, email: 'example3@example.com'

    create_list :activity, 4, user: second_user

    product = create :product
    licensed_product = create :spree_licensed_product,
                       user: first_user,
                       product: product

    create :spree_product_distribution,
           licensed_product: licensed_product,
           product: product,
           from_user: first_user,
           to_user: second_user

    create :spree_product_distribution,
           licensed_product: licensed_product,
           product: product,
           from_user: first_user,
           to_user: third_user

    visit 'resources/login'
    page.fill_in 'Email', with: first_user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'

    visit users_account_licenses_path
    click_link 'Export Users List'

    expect(page.status_code).to eq(200)
    expect(page.response_headers['Content-Type']).to eq('text/csv')
    expect(page).to have_content 'example2@example.com'
    expect(page).to have_content 'example3@example.com'
    expect(page).to have_content '4,'
    expect(page).to have_content '0,'
    expect(page).not_to have_content 'example8@example.com'
  end
end
