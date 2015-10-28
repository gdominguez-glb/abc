module Hightail
  class Client
    include Singleton

    def initialize
      @auth_token = request_auth_token
    end

    def request_auth_token
      res = HTTParty.post(
        (ENV['hightail_api_url'] + 'dpi/v1/auth'),
        {
          body: { email: ENV['hightail_email'], password: ENV['hightail_password'] },
          headers: { 'X-Api-Key' => ENV['hightail_api_key'], 'Accept' => 'application/json', 'X-Original-User-Agent' => 'API' }
        }
      )
      res.parsed_response['authToken']
    end

    def folder_info(folder_id)
      res = HTTParty.get(
        (ENV['hightail_api_url'] + "dpi/v1/folder/#{folder_id}"),
        {
          headers: { 'X-Api-Key' => ENV['hightail_api_key'], 'Accept' => 'application/json', 'X-Original-User-Agent' => 'API', 'X-Auth-Token' => @auth_token }
        }
      )
    end

  end
end
