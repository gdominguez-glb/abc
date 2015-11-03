class AddDelegateUserIdToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :delegate_user_id, :integer
  end
end
