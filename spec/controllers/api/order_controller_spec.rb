# frozen_string_literal: true

require 'rails_helper'

describe Api::OrderController do
  let(:application) do
    create(:application, name: 'test', scopes: 'public')
  end

  let(:token) do
    create(
      :access_token,
      application: application,
      resource_owner_id: user.id
    )
  end

  let(:user) do
    create(:gm_user, email: 'jon_doe@greatminds.net')
  end

  let(:product) do
    create(
      :product,
      name: 'Eureka Navigator LTI'
    )
  end

  let(:purchase_order) do
    Spree::PaymentMethod::PurchaseOrder.new
  end

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe 'POST #create' do
    it 'responds with 200' do
      request.env['HTTP_AUTHORIZATION'] = token.token
      params = {
        admin_new_licenses_form: {
          user_id: user.id,
          email: user.email,
          product_ids: [product.id],
          payment_method_id: 'cash',
          fulfillment_at: Date.today,
          salesforce_order_id: 'SF_100',
          salesforce_account_id: 'SF_100',
          sf_contact_id: 'SF_100',
          enable_single_distribution: true,
          allow_fulfill_without_salesforce: false,
          amount: '300'
        },
        payment_source: purchase_order.payment_source_class,
        admin_user: user,
        products: [product]
      }

      post :create, params, format: :json
      expect(response.code).to eq('200')
    end
  end
end
