class AddFromEmailToSpreeProductDistributions < ActiveRecord::Migration
  def change
    add_column :spree_product_distributions, :from_email, :string
  end
end
