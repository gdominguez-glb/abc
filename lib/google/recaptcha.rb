require 'uri'
require 'net/http'
require 'net/https'

module Google
  class Recaptcha
    class << self
      def status(object_id)
        data = {
            "secret" => ENV["google_recaptcha_secret"],
            "response" => object_id,
        }

        uri = URI.parse("https://www.google.com/recaptcha/api/siteverify")
        https = Net::HTTP.new(uri.host,uri.port)
        https.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
        req.set_form_data(data)
        res = https.request(req)

        JSON.parse(res.body).symbolize_keys
      rescue
        {
          "success" => false,
          "error-codes" => [
            "missing-input-response",
            "missing-input-secret"
          ]
        }.symbolize_keys
      end
    end
  end
end
