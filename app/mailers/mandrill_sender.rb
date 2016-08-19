require "mandrill"

class MandrillSender
  def initialize
    @host = "http://#{ActionMailer::Base.default_url_options[:host]}"
    @mandrill = Mandrill::API.new(ENV['mandrill_password'])
  end

  def deliver_with_template(template_name, email, subject, variables)
    template_content = []
    message = {
      to: [{email: email}],
      subject: subject,
      merge_vars: [
        {
          rcpt: email,
          vars: generate_vars(variables.merge(host: @host))
        } 
      ]
    }
    if Rails.env.qa? || Rails.env.staging? || Rails.env.production?
      @mandrill.messages.send_template(template_name, template_content, message)
    end
  end

  def generate_vars(variables)
    variables.map { |v| { name: v[0].to_s.upcase, content: v[1] } }
  end
end
