require 'httparty'

class Mailchimp
  include Singleton

  API_ROOT = 'https://us11.api.mailchimp.com/3.0/'

  LISTS = {
  }

  def self.subscribe(user_id)
    user = Spree::User.find(user_id)
    list_id = list_id_by_role(user)
    url = "#{API_ROOT}lists/#{list_id}/members"
    HTTParty.post(url, 
                  body: { status: 'subscribed', email_address: user.email }.to_json,
                  basic_auth: auth,
                  headers: { 'content-type' => 'application/json'}
                 )
  end

  def self.unsubscribe(user_id)
    user = Spree::User.find(user_id)
    list_id = list_id_by_role(user)
    url = "#{API_ROOT}lists/#{list_id}/members/#{Digest::MD5.hexdigest(user.email)}"
    HTTParty.delete(url, basic_auth: auth)
  end

  def self.auth
    { username: 'bearer', password: ENV['mailchimp_api_key'] }
  end

  def self.list_id_by_role(user)
    'c963f03f21'
  end
end
