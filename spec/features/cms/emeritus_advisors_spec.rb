require 'rails_helper'

describe 'Emeritus Advisors' do
  before(:each) do
    user = create :gm_user, email: 'example1@example.com'
    user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    user.save

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'create an emeritus advisor', js: true do
    visit 'cms/staffs/new'

    fill_in 'staff[name]', with: 'Luis Villa'
    fill_in 'staff[title]', with: 'Advisor'
    select 'emeritus_advisor', from: 'staff[staff_type]', visible: false
    fill_in 'staff[description]', with: 'This is a test bio.', visible: false
    check 'staff[display]'

    click_on 'Create Staff'

    visit 'cms/staffs/emeritus_advisors'

    expect(page).to have_content('Luis Villa')

    visit 'team/trustees'

    find('div[data-name="Luis Villa"]').click

    expect(page).to have_content('LUIS VILLA', count: 2)
    expect(page).to have_content('Advisor')
    expect(page).to have_content('This is a test bio.')
  end

  it 'delete an emeritus advisor', js: true do
    create :staff, staff_type: 2, name: 'Luis'

    visit 'cms/staffs/emeritus_advisors'

    expect(page).to have_content('Luis')

    click_on 'Delete'

    page.accept_alert

    visit 'cms/staffs/emeritus_advisors'

    expect(page).not_to have_content('Luis')
  end

  it 'update an emeritus advisor', js: true do
    create :staff, staff_type: 2, name: 'Luis'

    visit 'cms/staffs/emeritus_advisors'

    expect(page).to have_content('Luis')

    click_on 'Edit'

    fill_in 'staff[name]', with: 'Luis Villa'
    fill_in 'staff[title]', with: 'Advisor'
    select 'emeritus_advisor', from: 'staff[staff_type]', visible: false
    fill_in 'staff[description]', with: 'This is a test bio.', visible: false
    check 'staff[display]'

    click_on 'Update Staff'

    visit 'cms/staffs/emeritus_advisors'

    expect(page).to have_content('Luis Villa')

    visit 'team/trustees'

    find('div[data-name="Luis Villa"]').click

    expect(page).to have_content('LUIS VILLA', count: 2)
    expect(page).to have_content('Advisor')
    expect(page).to have_content('This is a test bio.')
  end
end
