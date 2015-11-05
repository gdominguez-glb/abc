class AddOrderIdAndEmailAndFirstNameAndLastNameAndFromEmailAndFromUserIdToLegacyLicenses < ActiveRecord::Migration
  def change
    add_column :legacy_licenses, :order_id, :integer
    add_column :legacy_licenses, :email, :string
    add_column :legacy_licenses, :first_name, :string
    add_column :legacy_licenses, :last_name, :string
    add_column :legacy_licenses, :from_email, :string
    add_column :legacy_licenses, :from_user_id, :integer
  end
end
