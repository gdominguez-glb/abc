require 'rails_helper'

describe 'Client credentials OAuth flow', type: :request do
  before :each do
    admin = create :gm_user,
                   email: 'web.admin@greatminds.net'
    admin.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
    admin.save

    product = create :product, name: 'Eureka Navigator LTI'
    licensed_product = create :spree_licensed_product,
                              user: admin,
                              product: product

    first_distributor = create :gm_user,
                                email: 'example2@example.com'
    first_distributor.spree_roles << Spree::Role.find_or_create_by(name: 'school admin')
    first_distributor.save

    create :spree_product_distribution,
           licensed_product: licensed_product,
           product: product,
           from_user: admin,
           quantity: 1000,
           to_user: first_distributor
  end

  it 'should get access token and post to users/create' do
    app = create :application, name: 'test', scopes: 'public'
    token = create :access_token, resource_owner_id: nil, application: app
    user = create :gm_user
    params = { spree_user: { first_name: 'Luis',
                             last_name: 'Gonzalez',
                             email: user.email }
    }

    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{token.token}"
    }

    post api_user_path, params, headers
    data = JSON.parse(response.body)
    data_response = JSON.parse Cypher.decrypt data["spree_user"]["id"]

    expect(response.status).to eq(201)
    expect(data.has_key?("spree_user")).to eq(true)
    expect(data["spree_user"].has_key?("id")).to eq(true)
    expect(data_response['id']).to eq(user.id)
    expect(data_response['token']).to eq(token.token)
  end

  it 'should get error when the firstname is empty' do
    app = create :application, name: 'test', scopes: 'public'
    token = create :access_token, resource_owner_id: nil, application: app
    params = { spree_user: { first_name: '',
                             last_name: 'Gonzalez',
                             email: 'luiscarlos.gonzalez@gmail.com' }
    }

    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{token.token}"
    }

    post api_user_path, params, headers
    data = JSON.parse(response.body)

    expect(data['errors'][0]).to eq('First name can\'t be blank')
  end

  it 'should get error when the lastname is empty' do
    app = create :application, name: 'test', scopes: 'public'
    token = create :access_token, resource_owner_id: nil, application: app
    params = { spree_user: { first_name: 'Luis',
                             last_name: '',
                             email: 'luiscarlos.gonzalez@gmail.com' }
    }

    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{token.token}"
    }

    post api_user_path, params, headers
    data = JSON.parse(response.body)

    expect(data['errors'][0]).to eq('Last name can\'t be blank')
  end

  it 'should get error when the email is empty' do
    app = create :application, name: 'test', scopes: 'public'
    token = create :access_token, resource_owner_id: nil, application: app
    params = { spree_user: { first_name: 'Luis',
                             last_name: 'Gonzalez',
                             email: '' }
    }

    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{token.token}"
    }

    post api_user_path, params, headers
    data = JSON.parse(response.body)

    expect(data['errors'][0]).to eq('Email can\'t be blank')
  end

  it 'should use invalid token and recieve a no authorize request' do
    app = create :application, name: 'test', scopes: 'public'
    token = 'clearly invalid token'

    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{token}"
    }

    post api_user_path, nil, headers

    expect(response.status).to eq(401)
  end

  it 'should not get the token using invalid client id' do
    app = create :application, name: 'test', scopes: 'public'

    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded'
    }

    post oauth_token_path, { client_id: 'invalid client',
                             secret_id: app.secret,
                             grant_type: 'client_credentials' },
                             headers

    expect(response.status).to eq(401)
  end

  it 'should not get the token using invalid secret' do
    app = create :application, name: 'test', scopes: 'public'

    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded'
    }

    post oauth_token_path, { client_id: app.uid,
                             secret_id: 'Invalid Secret',
                             grant_type: 'client_credentials' },
                             headers

    expect(response.status).to eq(401)
  end
end
