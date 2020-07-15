class AddExtraColumnToDoorkeeperTable < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_oauth_applications, :confidential, :boolean, null: false, default: true

    add_foreign_key(
      :spree_oauth_access_grants,
      :spree_oauth_applications,
      column: :application_id
    )

    add_foreign_key(
      :spree_oauth_access_tokens,
      :spree_oauth_applications,
      column: :application_id
    )
  end
end
