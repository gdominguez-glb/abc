class AddManualTitleToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :manual_title, :string
  end
end
