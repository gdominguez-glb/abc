require 'rails_helper'

describe 'Download file' do
  before(:each) do
    user = create :gm_user, email: 'example1@example.com'
    user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    user.save

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'downloads an excel file', js: true do
    visit 'cms/fall_institute_pds'

    expect(page).to have_link('Export As Xlsx', href: '/cms/fall_institute_pds.xlsx' )
  end
end
