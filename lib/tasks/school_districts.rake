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
end
