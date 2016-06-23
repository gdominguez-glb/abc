class UpdateColumnsInContacts < ActiveRecord::Migration
  def change
    remove_column :contacts, :name
    add_column :contacts, :first_name, :string
    add_column :contacts, :last_name, :string
    add_column :contacts, :topic, :string
  end
end
