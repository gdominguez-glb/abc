class RenameMafisToFamis < ActiveRecord::Migration
  def change
    rename_table :mafis_products, :famis_products
  end
end
