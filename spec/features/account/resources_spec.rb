# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe 'resource library' do
  before :each do
    create_distributions

    visit 'resources/login'

    page.fill_in 'Email', with: @user.email
    page.fill_in 'Password', with: '123456'
    page.click_button 'Sign in'
  end

  it 'search resource by name', js: true do
    visit 'account/resources'
    fill_in 'q', with: 'EUREKA NAVIGATOR LTI'
    page.execute_script("$('#search_resource').submit();")

    expect(page).to have_text('EUREKA NAVIGATOR LTI')
  end

  it 'search resource by taxonomies', js: true do
    visit 'account/resources'
    fill_in 'q', with: 'EUREKA NAVIGATOR LTI'
    expect(page).to have_text('EUREKA NAVIGATOR LTI')
  end

  def create_distributions
    @user = create(:gm_user, email: 'example1@example.com')
    @user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    @user.save

    @second_distributor = create :gm_user, email: 'example2@example.com'
    @second_distributor.spree_roles <<
      Spree::Role.find_or_create_by(name: 'admin')
    @second_distributor.save

    product =
      create(
        :product,
        name: 'Eureka Navigator LTI',
        product_type: 'library',
        show_in_storefront: true,
        individual_sale: true,
        for_sale: true,
        available_on: 1.days.ago
      )

    product2 = create :product, name: 'Wit and Wisdom', product_type: 'library'

    licensed_product1 =
      create :spree_licensed_product,
             user: @user,
             product: product,
             can_be_distributed: false

    licensed_product2 =
      create :spree_licensed_product,
             user: @user,
             product: product2,
             can_be_distributed: false

    create :spree_product_distribution,
           licensed_product: licensed_product1,
           product: product,
           from_user: @user,
           to_user: @second_distributor

    create :spree_product_distribution,
           licensed_product: licensed_product2,
           product: product2,
           from_user: @user,
           to_user: @second_distributor

    create(:activity, item: product, user: @user, action: 'buy')
    create(:activity, item: product2, user: @user, action: 'buy')

    grade_store_taxonomy =
      create(
        :taxonomy,
        name: 'Grade',
        show_in_store: true,
        show_in_video: false
      )

    grade_taxon =
      create(
        :spree_taxon,
        name: 'Grade',
        taxonomy: grade_store_taxonomy
      )

    gk_taxon =
      create(
        :spree_taxon,
        name: 'GK',
        taxonomy: grade_store_taxonomy,
        parent_id: grade_taxon
      )

    product.taxons << gk_taxon
  end
end
