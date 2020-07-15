class RenameDoorkeeperTable < ActiveRecord::Migration[5.2]
  def change
      remove_index :oauth_applications, :uid
      remove_index :oauth_access_grants, :token
      remove_index :oauth_access_tokens, :token
      remove_index :oauth_access_tokens, :resource_owner_id
      remove_index :oauth_access_tokens, :refresh_token

      rename_table :oauth_applications, :spree_oauth_applications
      rename_table :oauth_access_grants, :spree_oauth_access_grants
      rename_table :oauth_access_tokens, :spree_oauth_access_tokens

      add_index :spree_oauth_applications, :uid, unique: true
      add_index :spree_oauth_access_grants, :token, unique: true
      add_index :spree_oauth_access_tokens, :token, unique: true
      add_index :spree_oauth_access_tokens, :resource_owner_id
      add_index :spree_oauth_access_tokens, :refresh_token, unique: true
  end
end
