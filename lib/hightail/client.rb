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
      url = ENV['hightail_api_url'] + "dpi/v1/folder/#{folder_id}"
      res = HTTParty.get(url , { headers: headers })
      res.parsed_response
    end

    def download_file(file_id, dest_path)
      url          = ENV['hightail_api_url'] + "dpi/v1/folder/file/#{file_id}"
      res          = HTTParty.get(url, { headers: headers })
      download_url = ENV['hightail_api_url'] +  res.parsed_response['downloadUrl']
      uri          = URI(download_url)

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new uri
        request.initialize_http_header(headers)
        response = http.request(request)
        url = response.response['Location']
        download_real_file(url, dest_path)
      end
    end

    def download_real_file(url, dest_path)
      uri = URI(url)
      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new uri
        http.request request do |response|
          File.open dest_path, 'wb' do |io|
            response.read_body do |chunk|
              io.write chunk
            end
          end
        end
      end
    end

    def headers
      { 'X-Api-Key' => ENV['hightail_api_key'], 'Accept' => 'application/json', 'X-Original-User-Agent' => 'API', 'X-Auth-Token' => @auth_token }
    end
  end
end
