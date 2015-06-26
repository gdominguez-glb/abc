class LicenseMailer < ApplicationMailer

  def notify(licensed_product)
    @licensed_product = licensed_product
    email = licensed_product.user ? licensed_product.user.email : licensed_product.email

    mail to: email
  end
end
