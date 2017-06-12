class AddMandrillSubscriptionTemplateSlugAndMandrillPostTemplateSlugAndMailchimpListIdToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :mandrill_subscription_template_slug, :string
    add_column :blogs, :mandrill_post_template_slug, :string
    add_column :blogs, :mailchimp_list_id, :string
  end
end
