class AddMandrillSubscriptionTemplateSlugAndMailchimpPostTemplateIdAndMailchimpListIdToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :mandrill_subscription_template_slug, :string
    add_column :blogs, :mailchimp_post_template_id, :integer
    add_column :blogs, :mailchimp_list_id, :string
  end
end
