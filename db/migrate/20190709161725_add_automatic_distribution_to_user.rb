class AddAutomaticDistributionToUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :automatic_distribution, :boolean, default: true
  end
end
