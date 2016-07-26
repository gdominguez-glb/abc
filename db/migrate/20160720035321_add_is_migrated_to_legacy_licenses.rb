class AddIsMigratedToLegacyLicenses < ActiveRecord::Migration
  def change
    add_column :legacy_licenses, :is_migrated, :boolean, default: false
  end
end
