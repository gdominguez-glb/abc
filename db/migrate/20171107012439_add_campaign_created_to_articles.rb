class AddCampaignCreatedToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :campaign_created, :boolean, default: false
  end
end
