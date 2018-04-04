class AddAcceptedTerms2018AndAcceptedTerms2018AtToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :accepted_terms_2018, :boolean, default: false
    add_column :spree_users, :accepted_terms_2018_at, :datetime
  end
end
