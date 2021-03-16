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

  namespace :export_urls do
    desc "Export product acess urls from site"
    task all: :environment do
      file = "#{Rails.root}/tmp/product_url_data.csv"
      @products = Spree::Product.where(product_type: ['multiple download', 'group']).where('access_url ~* ?', '^.*\/download_pages\/.*$')
      headers = ['Product ID', 'Product Name', 'Url', 'Product Type', 'Slug']

      CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
        @products.each do |product|
          writer << [product.id, product.try(:name), product.try(:access_url), product.try(:product_type), product.try(:slug)]
        end
      end
    end
  end
end
