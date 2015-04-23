class AddMoreFieldsToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :address, :string
    add_column :spree_users, :interested_subject, :string
    add_column :spree_users, :interested_grade_level, :string
    add_column :spree_users, :receive_newsletter, :boolean
    add_column :spree_users, :school_name, :string
    add_column :spree_users, :heard_from, :string
  end
end
