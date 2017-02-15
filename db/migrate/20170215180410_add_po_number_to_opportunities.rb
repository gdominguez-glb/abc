class AddPoNumberToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :po_number, :string
  end
end
