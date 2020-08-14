# frozen_string_literal: true

require 'rails_helper'

describe Api::UserController do
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

  let(:user) { create(:gm_user, email: 'jon_doe@greatminds.net') }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  before(:each) do
    @admin = create :gm_user, email: 'web.admin@greatminds.net'
    @admin.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    @admin.save

    @product = create :product, name: 'Eureka Navigator LTI'

    licensed_product = create :spree_licensed_product,
                              user: @admin,
                              product: @product,
                              quantity: 10

    @second_user = create :gm_user, email: 'example2@example.com',
                                    first_name: 'Bruce',
                                    last_name: 'Wayne'

    create :spree_product_distribution,
           licensed_product: licensed_product,
           product: @product,
           from_user: @admin,
           to_user: @second_user,
           email: @second_user.email,
           quantity: 1

    create :spree_licensed_product,
           user: @admin,
           product: @product,
           quantity: 1,
           can_be_distributed: false
  end

  describe 'GET #info' do
    it 'responds with 200' do
      get :info

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['name']).to eq(
        user.full_name.to_s
      )
      expect(parsed_response['user_id']).to eq(user.id)
    end
  end

  describe 'POST #create' do
    it 'responds with 200' do
      request.env['HTTP_AUTHORIZATION'] = token.token
      post :create, params: {
                              spree_user: {
                                first_name: 'Jon',
                                last_name: 'Doe',
                                email: 'jon_doe@greatminds.net'
                              }
                            }, as: :json
      expect(response.code).to eq('201')
    end

    it 'responds with 500 if user not found' do
      request.env['HTTP_AUTHORIZATION'] = token.token
      post :create, params: {
                              spree_user: {
                                first_name: 'Jon',
                                last_name: 'Doe',
                                email: 'jon_doe@greatminds.net'
                              }
                            }, as: :json
      expect(response.code).to eq('500')
    end
  end
end
