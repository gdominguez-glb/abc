class AddReferralToSpreeUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :referral, :string
  end
end
