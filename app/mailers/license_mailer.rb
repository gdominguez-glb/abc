class LicenseMailer < ApplicationMailer

  def notify(licensed_product)
    @licensed_product = licensed_product
    email = licensed_product.user ? licensed_product.user.email : licensed_product.email

    mail to: email
  end

  def notify_fulfillment(order)
    @order = order
    @product_names = @order.line_items.map{|li| li.variant.product.name }.join(', ')
    @multiple = (@order.line_items.map(&:quantity).sum > @order.line_items.count)
    mail to: (order.user.try(:email) || order.email), subject: generate_subject('Great Minds Customer Service', @product_names, @multiple)
  end

  def notify_other_admin(order)
    @order = order
    @licenses_names = @order.line_items.map{|li| "#{li.quantity} #{li.variant.product.name}" }.join(', ')
    subject = "#{order.user.try(:full_name)} has made you a Great Minds Administrator"
    vars = {
      purchasing_admin_full_name: @order.user.try(:full_name),
      product_name: @licenses_names
    }
    MandrillSender.new.deliver_with_template('someone-else-will-distribute-these-licenses', order.license_admin_email, subject, vars)
  end

  def notify_distribution(attrs={})
    @school_admin = attrs[:school_admin]
    @product_name = attrs[:product_name]
    @quantity     = attrs[:quantity]
    to_email      = attrs[:to_email]
    @to_user      = Spree::User.find_by(email: to_email)

    mail to: to_email,  subject: generate_subject(@school_admin.full_name, [@product_name].join(', '), (@quantity.to_i > 1))
  end

  def generate_subject(admin_full_name, product_names, multiple=false)
    if multiple
      "#{admin_full_name} has assigned you #{product_names} licenses to distribute"
    else
      "#{admin_full_name} has given you access to #{product_names}"
    end
  end
end
