require 'inkling'

class InklingConnectWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = Spree::User.find_by(id: user_id)
    licenses = user.inkling_connect_licenses
    if licenses.present?
      Inkling.onboard(user, licenses)
    end
  end
end
