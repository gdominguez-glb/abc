class AddWistiaStatusToSpreeDigitals < ActiveRecord::Migration
  def change
    add_column :spree_digitals, :wistia_status, :string
  end
end
