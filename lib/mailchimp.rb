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

  SUBJECT_LISTS = {
    'Math' => 'd8714f2c62',
    'History' => 'abb1b31c20',
    'English' => 'c689119d94'
  }

  def self.subscribe_for_user(user_id)
    user     = Spree::User.find(user_id)
    list_ids = list_ids_by_role(user)

    list_ids.each do |list_id|
      subscribe(list_id, {
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name
      })
    end
  end

  def self.unsubscribe_user(user_id)
    user     = Spree::User.find(user_id)
    list_ids = list_ids_by_role(user)

    list_ids.each do |list_id|
      unsubscribe(list_id, user.email)
    end
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

  def self.list_ids_by_role(user)
    case user.title
    when 'Teacher', 'Parent'
      [ LISTS["General Great Minds Updates"] ] + list_ids_by_subjects(user.interested_curriculums)
    when 'Administrator', 'Administrative Assistant'
      LISTS.values
    else
      [ LISTS["General Great Minds Updates"] ]
    end
  end

  def self.list_ids_by_subjects(subjects)
    subjects.map{|s| SUBJECT_LISTS[s] }.compact
  end
end
