require 'rails_helper'

RSpec.describe Spree::HomeController, type: :controller do
  routes { Spree::Core::Engine.routes }

  describe "GET 'index'" do
    let!(:role_store_taxonomy) do
      create(
        :taxonomy,
        name: 'I am a...',
        show_in_store: true,
        show_in_video: false
      )
    end

    let!(:grade_store_taxonomy) do
      create(
        :taxonomy,
        name: 'Grade',
        show_in_store: true,
        show_in_video: false
      )
    end

    let!(:role_taxon) do
      create(
        :spree_taxon,
        name: 'I am a...',
        taxonomy: role_store_taxonomy
      )
    end

    let!(:grade_taxon) do
      create(
        :spree_taxon,
        name: 'Grade',
        taxonomy: grade_store_taxonomy
      )
    end

    let!(:gk_taxon) do
      create(
        :spree_taxon,
        name: 'GK',
        taxonomy: grade_store_taxonomy,
        parent_id: grade_taxon
      )
    end

    let!(:parent_taxon) do
      create(
        :spree_taxon,
        name: 'Parent',
        taxonomy: role_store_taxonomy,
        parent_id: role_taxon
      )
    end

    let!(:product) do
      create(
        :product,
        show_in_storefront: true,
        individual_sale: true,
        for_sale: true,
        available_on: 1.days.ago
      )
    end

    it 'should filter the list by shop name' do
      params = {
        q: product.name
      }
      get :index, params
      expect(response).to render_template :index
      expect(assigns(:products)).to eq([product])
    end

    it 'should filter the list by roles' do
      params = {
        r: 1,
        taxon_ids: [parent_taxon.id]
      }
      product.taxons << parent_taxon
      get :index, params
      expect(response).to render_template :index
      expect(assigns(:products)).to eq([product])
    end

    it 'should filter the list by grade' do
      params = {
        r: 1,
        taxon_ids: [gk_taxon.id]
      }
      product.taxons << gk_taxon
      get :index, params
      expect(response).to render_template :index
      expect(assigns(:products)).to eq([product])
    end

    it 'should clear the filter results' do
      params = {
        r: 1,
        taxon_ids: [gk_taxon.id],
        remove_all: true
      }
      product.taxons << gk_taxon
      get :index, params
    end
  end
end
