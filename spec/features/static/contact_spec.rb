require 'rails_helper'

describe 'User Registrations' do
  before(:each) do
    user = create :gm_user, email: 'example1@example.com'
    user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    user.save

    allow(Google::Recaptcha).to receive(:status).and_return({:success => true})
  end

  it 'should ask to select the topic first', js: true do
    visit '/contact'

    page.fill_in 'First Name', with: 'John'
    page.fill_in 'Last Name', with: 'Doe'
    page.fill_in 'Email', with: 'example2@example.com'
    page.fill_in 'contact_form[phone]', with: '123-123-1234'
    select 'Teacher', from: 'contact_form_role',
                      visible: false

    page.fill_in 'contact_form[school_district_name]', with: 'Test'
    page.fill_in 'contact_form[school_street_address]', with: 'Test'
    choose('contact_form[school_district_type]', option: 'District')

    select 'United States', from: 'contact_form_country',
                            visible: false

    click_on 'Submit'
    alert_text = page.driver.browser.switch_to.alert
    expect(alert_text.text.should).to eq('Please select topic first!')
  end

  it 'should submit the form, with topic', js: true do
    visit '/contact'

    page.execute_script("$('#contact_form_topic').val('General and Other');")

    page.fill_in 'First Name', with: 'John'
    page.fill_in 'Last Name', with: 'Doe'
    page.fill_in 'Email', with: 'example2@example.com'
    page.fill_in 'contact_form[phone]', with: '123-123-1234'
    select 'Teacher', from: 'contact_form_role',
                      visible: false

    page.fill_in 'contact_form[school_district_name]', with: 'Test'
    page.fill_in 'contact_form[school_street_address]', with: 'Test'
    choose('contact_form[school_district_type]', option: 'District')

    select 'United States', from: 'contact_form_country',
                            visible: false

    click_on 'Submit'
    alert_text = page.driver.browser.switch_to.alert
    expect(alert_text.text.should).to not_eq('Please select topic first!')
  end
end
