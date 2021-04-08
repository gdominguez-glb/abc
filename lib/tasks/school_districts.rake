namespace :school_districts do
  desc "Update city from ShippingCity"
  task update_city: :environment do
    SchoolDistrict.find_each do |sd|
      if sd.salesforce_reference &&
         sd.salesforce_reference.object_properties &&
         sd.salesforce_reference.object_properties['ShippingCity'].present?
        print '.'
        sd.update_column(:city, sd.salesforce_reference.object_properties['ShippingCity'])
      end
    end
    puts ''
  end

  # Add the school district e.g rake school_districts:add_school_district['School Name',3580, 232, "school"]
  desc 'Create a new School Or District'
  task :add_school_district, [:name, :state_id, :country_id, :place_type] => :environment do |_t, args|
    school_district = SchoolDistrict.where(
      name: args[:name],
      place_type: args[:place_type]
    ).first_or_create!(
      skip_salesforce_create: true,
      state_id: args[:state_id],
      country_id: args[:country_id],
      city: 'Cheyenne'
    )
    puts 'SchoolDistrict get created'
    puts school_district.inspect
  end
end
