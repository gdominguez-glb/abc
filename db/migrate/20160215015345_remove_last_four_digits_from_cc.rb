class RemoveLastFourDigitsFromCc < ActiveRecord::Migration
  def up
    remove_column :spree_credit_cards, :last_digits
  end

  def down
    add_column :spree_credit_cards, :last_digits, :string
  end
end
