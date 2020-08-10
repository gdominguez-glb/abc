require 'rails_helper'

describe 'User Registrations' do
  before(:each) do
    create(:curriculum, name: 'Math')
    allow(Google::Recaptcha).to receive(:status).and_return({:success => true})
  end

  it 'should register a user with valid params', js: true do
    visit 'resources/signup'

    page.fill_in 'First Name', with: 'John'
    page.fill_in 'Last Name', with: 'Doe'
    page.fill_in 'Email', with: 'example2@example.com'
    page.fill_in 'Password', with: '123456'
    page.fill_in 'spree_user[zip_code]', with: '33333'
    page.execute_script("$('#spree_user_interested_subjects').val(1);")
    select 'Homeschooler', from: 'spree_user_title',
                           visible: false

    page.click_button 'Create'
    expect(page).to have_content('TERMS OF SERVICE FOR USE OF THIS WEBSITE')
  end

  it 'should throw error for zip code', js: true do
    visit 'resources/signup'

    page.fill_in 'First Name', with: 'John'
    page.fill_in 'Last Name', with: 'Doe'
    page.fill_in 'Email', with: 'example2@example.com'
    page.fill_in 'Password', with: '123456'

    page.execute_script("$('#spree_user_interested_subjects').val(1);")
    select 'Homeschooler', from: 'spree_user_title',
                           visible: false

    page.click_button 'Create'
    expect(page).to have_content("Zip code can't be blank")
  end

  it 'should throw error for First Name/ Last Name', js: true do
    visit 'resources/signup'

    page.fill_in 'Email', with: 'example2@example.com'
    page.fill_in 'Password', with: '123456'
    page.fill_in 'spree_user[zip_code]', with: '33333'

    page.execute_script("$('#spree_user_interested_subjects').val(1);")
    select 'Homeschooler', from: 'spree_user_title',
                           visible: false

    page.click_button 'Create'
    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
  end
end
