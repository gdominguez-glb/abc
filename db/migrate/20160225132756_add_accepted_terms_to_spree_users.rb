class AddAcceptedTermsToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :accepted_terms, :boolean, default: false
  end
end
