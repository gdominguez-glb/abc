# This migration comes from spree_better_terms_and_conditions (originally 20140422104152)
class AddTermsAndConditionsToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :terms_and_conditions, :boolean
  end
end
