class ChangeFamisGradeToString < ActiveRecord::Migration
  def up
    change_column(:famis_products, :grade, :string)
  end

  def down
    change_column(:famis_products, :grade, :integer)
  end
end
