require 'rails_helper'

describe 'Whitelist' do
  before(:each) do
    user = create :gm_user, email: 'example1@example.com'
    user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    user.save

    @country = Spree::Country.find_by(iso: 'US')
    @country.update name: 'United States'

    visit 'resources/login'

    page.fill_in 'Email', with: user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'create new school entry', js: true do
    state = Spree::Country.find_by(iso: 'US').states.first
    state.update name: 'New York'

    create :school_district, name: 'Colegio Motolinia',
                             country: @country,
                             state: state

    visit '/resources/admin/whitelist'
    select 'New York', from: 'state_id'
    select2 'COLEGIO MOTOLINIA - NEW YORK', css: '#s2id_whitelist_school_district_id'
    click_button 'Add'

    expect(page).to have_text('Colegio Motolinia')
  end

  it 'create new district entry', js: true do
    state = Spree::Country.find_by(iso: 'US').states.first
    state.update name: 'California'

    create :school_district, name: 'District 9',
                             country: @country,
                             state: state,
                             city: 'San Francisco',
                             place_type: SchoolDistrict.place_types[:district]

    visit '/resources/admin/whitelist'
    click_link 'Multiple Schools/District'
    select 'California', from: 'state_id'
    select2 'DISTRICT 9 - SAN FRANCISCO', css: '#s2id_whitelist_school_district_id'
    click_button 'Add'
    click_link 'Multiple Schools/District'

    expect(page).to have_text('District 9')
  end

  it 'delete school entry', js: true do
    state = Spree::Country.find_by(iso: 'US').states.first
    state.update name: 'Chicago'

    school = create :school_district, name: 'Colegio Motolinia',
                                        country: @country,
                                        state: state
    create :spree_whitelist, school_district: school

    visit '/resources/admin/whitelist'
    page.accept_confirm { click_on class: 'delete-resource' }

    expect(page).to have_no_content('Colegio Motolinia')
  end

  it 'delete district entry', js: true do
    state = Spree::Country.find_by(iso: 'US').states.first
    state.update name: 'Denver'

    district = create :school_district, name: 'District 9',
                                        country: @country,
                                        state: state,
                                        place_type: SchoolDistrict.place_types[:district]

    create :spree_whitelist, school_district: district

    visit '/resources/admin/whitelist'
    click_link 'Multiple Schools/District'
    page.accept_confirm { click_on class: 'delete-resource' }
    click_link 'Multiple Schools/District'

    expect(page).to have_no_content('District 9')
  end
end
