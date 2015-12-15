class LicenseMailer < ApplicationMailer

  def notify(licensed_product)
    @licensed_product = licensed_product
    email = licensed_product.user ? licensed_product.user.email : licensed_product.email

    mail to: email
  end

  def notify_fulfillment(order)
    @order = order
    @product_names = @order.line_items.map{|li| li.variant.product.name }.join(', ')
    mail to: (order.user.try(:email) || order.email), subject: "#{order.admin_user.try(:full_name)} has given you access to #{@product_names}"
  end

  def notify_other_admin(order)
    @order = order
    @licenses_names = @order.line_items.map{|li| "#{li.quantity} #{li.variant.product.name}" }.join(', ')
    mail to: order.license_admin_email, subject: "#{order.user.try(:full_name)} has made you a Great Minds Administrator"
  end

  def notify_distribution(attrs={})
    @school_admin = attrs[:school_admin]
    @product_name = attrs[:product_name]
    @quantity     = attrs[:quantity]
    to_email      = attrs[:to_email]

    mail to: to_email,  subject: "#{@school_admin.full_name} has assigned you #{@product_name} licenses to distribute"
  end
end
