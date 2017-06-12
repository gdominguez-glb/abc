class SubscriptionWorker

  def self.perform(blog_id, user_id)
    blog = Blog.find(blog_id)
    user = Spree::User.find(user_id)

    # add user to mailchimp list members
    if blog.mailchimp_list_id.present?
      Mailchimp.subscribe(blog.mailchimp_list_id, {
                                    email: user.email,
                                    first_name: user.first_name,
                                    last_name: user.last_name,
                                    zip_code: user.zip_code,
                                    role: user.title, 
                                    state: (user.state_name || '')
                          })
    end

    # send email on the subscription through mandrill template
    if blog.mandrill_subscription_template_slug.present?
      MandrillSender.new.deliver_with_template(blog.mandrill_subscription_template_slug, user.email, "Subscribed to #{blog.title} successfully", { fname: user.first_name })
    end
  end
end
