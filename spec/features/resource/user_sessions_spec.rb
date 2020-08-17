# frozen_string_literal: true

require 'rails_helper'

describe 'user_sessions' do
  before :each do
    ghost_user = create :gm_user, email: 'ghost@example.com'
    ghost_user.save
    user = create :gm_user, email: 'example1@example.com'
    user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    user.save

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'becomes user', js: true do
    visit '/resources/admin/users'
    click_link('Login As', match: :first)
    expect(page).to have_content('Now logged in as ghost@example.com')
  end

  it 'already logged in', js: true do
    visit '/resources/admin/users'
    page.all('a')[27].click
    expect(page).to have_content('Already logged in as example1@example.com')
  end
end
