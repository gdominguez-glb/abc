class AddAllowCommunicationToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :allow_communication, :boolean, default: true
  end
end
