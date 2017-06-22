class AddMailchimpCampaignIdToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :mailchimp_campaign_id, :string
  end
end
