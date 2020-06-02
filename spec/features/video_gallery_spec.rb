require 'rails_helper'

describe 'Video Gallery' do
  before(:each) do
    user = create :gm_user, email: 'example1@example.com'
    user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    user.save

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'should display the list of videos', js: true do
    create :spree_video, is_free: true

    visit '/video_gallery'
    # expect(page).to have_selector('div.video-card', count: 1)
    expect(page).to have_content("MY VIDEOS (#{1})")
  end

  it 'should filter out the list of videos', js: true do
    sp_video1 = create :spree_video, title: 'name'
    create :spree_video, title: 'lorem ipsumi dolor'

    visit '/video_gallery'
    # fill_in '#video-search', with: sp_video1.title
    page.execute_script("$('#video-search').val('#{sp_video1.title}');")
    page.execute_script("$('#video_search_form').submit();")

    # expect(page).to have_selector('div.video-card', count: 1)
    expect(page).to have_content("MY VIDEOS (#{1})")
  end
end
