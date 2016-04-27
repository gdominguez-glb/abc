class AddIndexesToSchoolDistricts < ActiveRecord::Migration
  def change
    add_index :school_districts, :name
    add_index :school_districts, :state_id
  end
end
