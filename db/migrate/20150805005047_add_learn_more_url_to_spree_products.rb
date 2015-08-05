class AddLearnMoreUrlToSpreeProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :learn_more_url, :string
  end
end
