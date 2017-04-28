namespace :product do
  namespace :export do
    desc "Export all products from site"
    task all: :environment do
      CSV.open("#{Rails.root}/tmp/products.csv", "wb") do |csv|
        csv << ["ID", "Name", "Internal Name"]
        Spree::Product.find_each do |p|
          csv << [p.id, p.name, p.internal_name]
        end
      end
    end
  end
end