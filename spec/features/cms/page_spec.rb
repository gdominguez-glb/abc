require 'rails_helper'

describe 'Page' do
  before(:each) do
    user = create :gm_user, email: 'example1@example.com'
    user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    user.save

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'create page', js: true do
    visit 'cms/pages/new'

    select '50/50 Content Image Left, Half Height', from: 'row_type', visible: false
    click_button 'Add New Tile Row'
    find('input[data-name="title"]').set("Rspec Test")


    find('option[value="purple"]').click

    click_on 'Metadata'

    fill_in 'page_slug', with: 'rspec-test'
    fill_in 'page_title', with: 'Rspec Test'
    fill_in 'page_group_name', with: 'rspec'

    expect(page).to have_css '.purple-bg'

    click_button 'Save Draft'
    click_on 'Preview Page'

    expect(page.find(".purple-bg").present?).to be_truthy
  end
end
