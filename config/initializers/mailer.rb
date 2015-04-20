if Rails.env.development?
  ActionMailer::Base.delivery_method = :letter_opener
else
  ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    address:              "smtp.mandrillapp.com",
    port:                 587,
    enable_starttls_auto: true,
    domain:               "gm-#{Rails.env.downcase}.intridea.com",
    user_name:            "web.admin@greatminds.net",
    password:             "1W0RAoHxNG_o-IeS9VeFBA"
  }
end

if ENV['DOMAIN']
  ActionMailer::Base.default_url_options[:host] = ENV['DOMAIN']
end
