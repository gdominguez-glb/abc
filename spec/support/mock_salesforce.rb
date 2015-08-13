shared_context 'mock_salesforce' do
  before do
    body = JSON.parse(File.read(File.join(Rails.root, 'spec', 'fixtures', 'sf_login_response.json'))).to_json
    stub_request(:post, "https://test.salesforce.com/services/oauth2/token")
      .with(:body => {"client_id"=>"3MVG9Nc1qcZ7BbZ1XpVUs3UlnsFbsp3ztG_SEe7plG26z5xvBs94HFoNiYyocFiLC1eRH.PLc249S1YbHIrxB", "client_secret"=>"3250542473237550008", "grant_type"=>"password", "password"=>"intridea5gmrZj49NL9ZjublFkGjCr06tOl", "username"=>"maggie@greatminds.net.intridea"},
           :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.9.1'})
      .to_return(:status => 200, :body => body, :headers => {})

    headers = {"date"=>"Thu, 13 Aug 2015 19:00:13 GMT", "set-cookie"=>"BrowserId=3C57i9qBSV6ruuLh8bMMaQ;Path=/;Domain=.salesforce.com;Expires=Mon, 12-Oct-2015 19:00:13 GMT", "expires"=>"Thu, 01 Jan 1970 00:00:00 GMT", "sforce-limit-info"=>"api-usage=9/72000", "org.eclipse.jetty.server.include.etag"=>"31f0223f", "last-modified"=>"Tue, 11 Aug 2015 17:56:53 GMT", "content-type"=>"application/json;charset=UTF-8", "etag"=>"31f0223-gzip\"", "transfer-encoding"=>"chunked", "connection"=>"close"}
    body = JSON.parse(File.read(File.join(Rails.root, 'spec', 'fixtures', 'sf_account_columns_response.json'))).to_json
    stub_request(:get, "https://test.salesforce.com/services/data/v32.0/sobjects/Account/describe")
      .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'OAuth 00Dx0000000BV7z!AR8AQAxo9UfVkh8AlV0Gomt9Czx9LjHnSSpwBMmbRcgKFmxOtvxjTrKW19ye6PE3Ds1eQz3z8jr3W7_VbWmEu4Q8TVGSTHxs', 'User-Agent'=>'Faraday v0.9.1'})
      .to_return(:status => 200, :body => body, :headers => headers)

  end
end
