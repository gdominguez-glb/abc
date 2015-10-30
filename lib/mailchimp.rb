require 'httparty'

class Mailchimp
  include Singleton

  API_ROOT = 'https://us11.api.mailchimp.com/3.0/'

  LISTS = {
    "Art updates" => "51bebc0779",
    "ELA updates" => "c689119d94",
    "General Great Minds Updates" => "1df83dd41d",
    "History Updates (Alexandria Plan)"=>"abb1b31c20",
    "Math Updates (Eureka Math)"=>"d8714f2c62"
  }

  def self.subscribe_for_user(user_id)
    user    = Spree::User.find(user_id)
    list_id = list_id_by_role(user)
    subscribe(list_id, {
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name
    })
  end

  def self.unsubscribe_user(user_id)
    user    = Spree::User.find(user_id)
    list_id = list_id_by_role(user)
    unsubscribe(list_id, user.email)
  end

  def self.subscribe(list_id, info={})
    url = "#{API_ROOT}lists/#{list_id}/members"
    HTTParty.post(url, 
                  body: { status: 'subscribed', email_address: info[:email], merge_fields: {FNAME: info[:first_name], LNAME: info[:last_name] } }.to_json,
                  basic_auth: auth,
                  headers: { 'content-type' => 'application/json'}
                 )
  end

  def self.unsubscribe(list_id, email)
    url = "#{API_ROOT}lists/#{list_id}/members/#{Digest::MD5.hexdigest(email)}"
    HTTParty.delete(url, basic_auth: auth)
  end

  def self.lists
    url = "#{API_ROOT}lists"
    res = HTTParty.get(url,
                  basic_auth: auth,
                  headers: { 'content-type' => 'application/json'}
                 )
    res.parsed_response
  end

  def self.auth
    { username: 'bearer', password: ENV['mailchimp_api_key'] }
  end

  def self.list_id_by_role(user)
    'c963f03f21'
  end

  def self.list_id_by_subject(subject)
  end
end
