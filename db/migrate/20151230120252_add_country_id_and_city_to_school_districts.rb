class AddCountryIdAndCityToSchoolDistricts < ActiveRecord::Migration
  def up
    add_column :school_districts, :country_id, :integer
    add_column :school_districts, :city, :string

    SchoolDistrict.all.each do |school_district|
      if school_district.state
        school_district.update(country_id: school_district.state.country_id)
      end
    end
  end

  def down
    remove_column :school_districts, :country_id
    remove_column :school_districts, :city
  end
end
