class AddWistiaIdAndWistiaHashedIdToSpreeDigitals < ActiveRecord::Migration
  def change
    add_column :spree_digitals, :wistia_id, :integer
    add_column :spree_digitals, :wistia_hashed_id, :string
  end
end
