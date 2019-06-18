require 'rails_helper'

describe 'Client credentials OAuth flow', type: :request do
  it 'should get access token and post to users/create' do
    app = create :application, name: 'test', scopes: 'public'
    token = create :access_token, resource_owner_id: nil, application: app

    headers = {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Bearer #{token.token}"
    }

    post api_user_path, nil, headers
    success = JSON.parse(response.body)['success']

    expect(success).to eq('Success')
    expect(response.status).to eq(201)
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
