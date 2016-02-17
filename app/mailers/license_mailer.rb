class LicenseMailer < ApplicationMailer

  def notify(licensed_product)
    @licensed_product = licensed_product
    email = licensed_product.user ? licensed_product.user.email : licensed_product.email

    mail to: email
  end

  def notify_fulfillment(order)
    @order = order
    @multiple = (@order.line_items.map(&:quantity).sum > @order.line_items.count)
    @product_names = order.line_items.map{|li| li.variant.product.name }.join(', ')
    recipient = (order.user.try(:email) || order.email)
    subject = generate_subject('Great Minds Customer Service', @product_names, @multiple)
    if @multiple
      notify_multiple_fulfillment(recipient, subject, @order)
    else
      notify_single_fulfillment(recipient, subject, order, @product_names)
    end
  end

  def notify_multiple_fulfillment(recipient, subject, order)
    vars = {
      admin_full_name: 'Great Minds Customer Service',
      licenses_product_names: order.line_items.map{|li| "#{li.quantity} licenses for #{li.variant.product.name}"}.join(', ')
    }
    MandrillSender.new.deliver_with_template('new-or-existing-user-given-multiple-licenses-for-product-by-an-administrator', recipient, subject, vars)
  end

  def notify_single_fulfillment(recipient, subject, order, product_names)
    vars = {
      user_first_name: order.user.try(:first_name),
      bundle_product_name: product_names
    }
    template_name = order.user.present? ? 'new-license-assigned-email-user-does-exist' : 'new-license-assigned-email-user-doesn-t-exist'
    MandrillSender.new.deliver_with_template(template_name, recipient, subject, vars)
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

    subject = generate_subject(@school_admin.full_name, [@product_name].join(', '), (@quantity.to_i > 1))
    if @quantity > 1
      notify_multiple_distribution(@school_admin.admin_full_name, to_email, subject, @quantity, @product_name)
    else
      notify_single_distribution(to_email, @to_user, @product_name, subject)
    end
    # mail to: to_email,  subject: generate_subject(@school_admin.full_name, [@product_name].join(', '), (@quantity.to_i > 1))
  end

  def notify_multiple_distribution(admin_full_name, to_email, subject, quantity, product_name)
    vars = {
      admin_full_name: admin_full_name,
      licenses_product_names: "#{quantity} licenses for #{product_name}"
    }
    MandrillSender.new.deliver_with_template('new-or-existing-user-given-multiple-licenses-for-product-by-an-administrator', to_email, subject, vars)
  end

  def notify_single_distribution(to_email, to_user, product_name, subject)
    vars = {
      user_first_name: to_user.try(:first_name),
      bundle_product_name: product_name
    }
    template_name = to_user.present? ? 'new-license-assigned-email-user-does-exist' : 'new-license-assigned-email-user-doesn-t-exist'
    MandrillSender.new.deliver_with_template(template_name, to_email, subject, vars)
  end

  def generate_subject(admin_full_name, product_names, multiple=false)
    if multiple
      "#{admin_full_name} has assigned you #{product_names} licenses to distribute"
    else
      "#{admin_full_name} has given you access to #{product_names}"
    end
  end
end
