if Rails.env.development?
  ActionMailer::Base.delivery_method = :letter_opener
else
  ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    address:              "smtp.mandrillapp.com",
    port:                 587,
    enable_starttls_auto: true,
    domain:               ENV['DOMAIN'],
    user_name:            ENV['mandrill_username'],
    password:             ENV['mandrill_password']
  }
end

if ENV['DOMAIN']
  ActionMailer::Base.default_url_options[:host] = ENV['DOMAIN']
end
