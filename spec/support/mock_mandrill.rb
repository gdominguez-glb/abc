module MockMandrill
  def mock_mandrill_delivery
    ENV['mandrill_password'] = 'mock_api_key_123'
    stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send-template.json").
         with(:body => /.*/,
              :headers => {'Content-Type'=>'application/json', 'Host'=>'mandrillapp.com:443', 'User-Agent'=>'excon/0.45.4'}).
         to_return(:status => 200, :body => "{}", :headers => {})
  end
end
