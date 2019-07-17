require 'rails_helper'
require 'sidekiq/testing'

describe 'Client credentials OAuth flow', type: :request do
  before :each do
    app = create :application, name: 'test', scopes: 'public'
    @token = create :access_token, resource_owner_id: nil, application: app
  end

  it 'should create an order en distribute licenses to the school admin' do
    user = create :gm_user
    product = create :product, sf_id_product: '123456789123456789'
    params = {
      admin_new_licenses_form: {
        user_id: '',
        email: user.email,
        enable_single_distribution: '0',
        fulfillment_at: '2019/07/15',
        salesforce_order_id: '8014F000000mReyQAE',
        salesforce_account_id: '0014F00000HoLECQA3',
        sf_contact_id: '0034F00000IFe2GQAT',
        amount: 116.00,
        payment_method_id: '3'
      },
      payment_source: {
        3 => {
          po_number: '987654321'
        }
      },
      products: {
        123456789123456789 => 17
      }
    }


    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{@token.token}"
    }

    post api_order_path, params, headers
    expect(response.status).to eq(200)

    LicensesDistributionWorker.drain

    user.reload
    order = Spree::Order.find_by email: user.email
    licensed_product =  Spree::LicensedProduct.find_by email: user.email,
                                                       can_be_distributed: true

    expect(order.email).to eq(user.email)
    expect(user.product_distributions.count).to eq(1)
    expect(licensed_product.quantity).to eq(16)
  end

  it 'should fail if the product doesn\'t exists' do
    user = create :gm_user
    params = {
      admin_new_licenses_form: {
        user_id: '',
        email: user.email,
        enable_single_distribution: '0',
        fulfillment_at: '2019/07/15',
        salesforce_order_id: '8014F000000mReyQAE',
        salesforce_account_id: '0014F00000HoLECQA3',
        sf_contact_id: '0034F00000IFe2GQAT',
        amount: 116.00,
        payment_method_id: '3'
      },
      payment_source: {
        3 => {
          po_number: '987654321'
        }
      },
      products: {
        123456789987654321 => 17
      }
    }


    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{@token.token}"
    }

    post api_order_path, params, headers
    data = JSON.parse(response.body)

    expect(data['base'].first).to eq('Product not found')
  end

  it 'should create an order and if the user doesn\'t exists should send an email notification' do
    user = create :gm_user
    product = create :product, sf_id_product: '123456789123456789'
    params = {
      admin_new_licenses_form: {
        user_id: '',
        email: user.email,
        enable_single_distribution: '0',
        fulfillment_at: '2019/07/15',
        salesforce_order_id: '8014F000000mReyQAE',
        salesforce_account_id: '0014F00000HoLECQA3',
        sf_contact_id: '0034F00000IFe2GQAT',
        amount: 116.00,
        payment_method_id: '3'
      },
      payment_source: {
        3 => {
          po_number: '987654321'
        }
      },
      products: {
        123456789123456789 => 17
      }
    }


    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{@token.token}"
    }

    post api_order_path, params, headers
    expect(response.status).to eq(200)

    LicensesDistributionWorker.drain

    user.reload
    order = Spree::Order.find_by email: user.email
    licensed_product =  Spree::LicensedProduct.find_by email: user.email,
                                                       can_be_distributed: true

    expect(order.email).to eq(user.email)
    expect(licensed_product.quantity).to eq(16)
  end
end
