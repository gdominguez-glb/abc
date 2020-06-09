# frozen_string_literal: true

require 'rails_helper'

describe 'General Settings' do
  before :each do
    user = create :gm_user, email: 'example1@example.com'
    user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    user.save

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'clear cache', js: true do
    visit '/resources/admin/general_settings/edit'
    page.click_button 'Clear Cache'
    expect(page).to have_selector('.alert', text: 'Cache was flushed')
  end
end
