shared_context 'mock_salesforce' do
  let(:sf_auth_token) do
    '00Dx0000000BV7z!AR8AQAxo9UfVkh8AlV0Gomt9Czx9LjHnSSpwBMmbRcgKFmxOtvxj' \
    'TrKW19ye6PE3Ds1eQz3z8jr3W7_VbWmEu4Q8TVGSTHxs'
  end
  let(:base_sf_url) { 'https://test.salesforce.com/services' }
  let(:sf_accept_encoding) { 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3' }
  let(:sf_api_version) { '38.0' }

  let(:salesforce_client_id) { 'client_id' }
  let(:salesforce_client_secret) { 'client_secret' }

  let(:salesforce_username) { 'username' }
  let(:salesforce_password) { 'password' }
  let(:salesforce_security_token) { 'token' }

  let(:sf_auth_params) do
    pass = "#{salesforce_password}#{salesforce_security_token}"
    {
      client_id: salesforce_client_id,
      client_secret: salesforce_client_secret,
      grant_type: 'password',
      password: pass,
      username: salesforce_username
    }
  end

  def sf_fixture(name)
    File.read(File.join(Rails.root, 'spec', 'fixtures', "#{name}.json"))
  end

  def request_headers(extra_headers = {}, authorization = true)
    headers = { 'Accept' => '*/*',
                'Accept-Encoding' => sf_accept_encoding,
                'User-Agent' => 'Faraday v0.9.1' }
    headers.merge!('Authorization' => "OAuth #{sf_auth_token}") if authorization
    headers.merge extra_headers
  end

  def response_headers(extra_headers = {}, content = true, etag = nil)
    r_headers = { date: 'Thu, 13 Aug 2015 19:00:13 GMT',
                  'set-cookie' => 'BrowserId=3C57i9qBSV6ruuLh8bMMaQ;Path=/;' \
                    'Domain=.salesforce.com;Expires=' \
                    'Mon, 12-Oct-2015 19:00:13 GMT',
                  expires: 'Thu, 01 Jan 1970 00:00:00 GMT',
                  'sforce-limit-info' => 'api-usage=9/72000',
                  'transfer-encoding' => 'chunked',
                  connection: 'close' }
    r_headers.merge!(
      'last-modified' => 'Tue, 11 Aug 2015 17:56:53 GMT',
      'content-type' => 'application/json;charset=UTF-8') if content
    r_headers.merge!('org.eclipse.jetty.server.include.etag' => "#{etag}f",
                     etag: "#{etag}-gzip\"") if etag
    r_headers.merge(extra_headers)
  end

  def sf_mock_describe(sobject = 'Account',
                       r_body = sf_fixture('sf_account_columns_response'))
    stub_request(:get, "#{base_sf_url}/data/v#{sf_api_version}/sobjects/" \
      "#{sobject}/describe")
      .with(headers: request_headers)
      .to_return(status: 200, body: r_body,
                 headers: response_headers({}, true, '31f0223'))
  end

  def sf_mock_find(sobject = 'Account', sobject_id = '001e000000en0LsAAI',
                   r_body = sf_fixture('sf_account_response'))
    stub_request(:get, "#{base_sf_url}/data/v#{sf_api_version}/sobjects/" \
                       "#{sobject}/#{sobject_id}")
      .with(headers: request_headers)
      .to_return(status: 200, body: r_body, headers: response_headers)
  end

  def sf_mock_find_all(
      sobject = 'Account',
      sobject_columns = 'Id,Name,BillingState,BillingCountry',
      r_body = sf_fixture('sf_account_find_all_response'))
    stub_request(:get, "#{base_sf_url}/data/v#{sf_api_version}/sobjects/" \
      "#{sobject}/#{sobject_columns}")
      .with(headers: request_headers)
      .to_return(status: 200, body: r_body, headers: response_headers)
  end

  def sf_mock_create(sobject = 'Account', id = '001e000000fhMnpAAE',
                     properties = { 'Name' => 'Test School',
                                    'RecordTypeId' => '012i00000019vQaAAI',
                                    'BillingState' => 'MD',
                                    'BillingCountry' => 'USA' })
    r_body = { id: id, success: true, errors: [] }.to_json
    stub_request(:post, "#{base_sf_url}/data/v#{sf_api_version}/sobjects/" \
                        "#{sobject}")
      .with(body: properties.to_json,
            headers: request_headers('Content-Type' => 'application/json'))
      .to_return(status: 200, body: r_body, headers: response_headers(
        location: "/services/data/v#{sf_api_version}/sobjects/#{sobject}/#{id}")
      )
  end

  def sf_mock_update(sobject = 'Account', id = '001e000000fhMnpAAE',
                     properties = { 'Name' => 'New Test School' })
    stub_request(:patch, "#{base_sf_url}/data/v#{sf_api_version}/sobjects/" \
      "#{sobject}/#{id}")
      .with(body: properties.to_json,
            headers: request_headers('Content-Type' => 'application/json'))
      .to_return(status: 200, body: '', headers: response_headers({}, false))
  end

  def set_env_variables
    Spree::Config[:salesforce_client_id] = salesforce_client_id
    Spree::Config[:salesforce_client_secret] = salesforce_client_secret

    Spree::Config[:salesforce_username] = salesforce_username
    Spree::Config[:salesforce_password] = salesforce_password
    Spree::Config[:salesforce_security_token] = salesforce_security_token
  end

  before do
    set_env_variables
    # Authenticate
    stub_request(:post, "#{base_sf_url}/oauth2/token")
      .with(body: sf_auth_params,
            headers: request_headers(
              { 'Content-Type' => 'application/x-www-form-urlencoded' }, false))
      .to_return(status: 200,
                 body: sf_fixture('sf_login_response'),
                 headers: {})
  end
end
