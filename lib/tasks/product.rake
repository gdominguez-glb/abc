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

  namespace :set_meta_title do
    desc "Set Meta title for product"
    task all: :environment do
      product = Spree::Product.where(slug: 'eureka-parent-tip-sheets').first
      if product.present?
        product.meta_title = 'Family Tip Sheets'
        product.save
      end

      product = Spree::Product.where(slug: 'eureka-digital-suite-group').first
      if product.present?
        product.meta_title = 'Eureka Digital Suite'
        product.save
      end

      product = Spree::Product.where(slug: 'wit-wisdom-assessment-resources').first
      if product.present?
        product.meta_title = 'Assessment Resources'
        product.save
      end

      product = Spree::Product.where(slug: 'state-alignment-studies').first
      if product.present?
        product.meta_title = 'State Alignment Studies'
        product.save
      end

      product = Spree::Product.where(slug: 'wit-wisdom-family-tip-sheets').first
      if product.present?
        product.meta_title = 'Family Tip Sheets'
        product.save
      end

      product = Spree::Product.where(slug: 'eureka-spanish-grade-roadmaps').first
      if product.present?
        product.meta_title = 'Spanish Grade Roadmaps'
        product.save
      end

      product = Spree::Product.where(slug: 'copy-of-homework-helpers-samples').first
      if product.present?
        product.meta_title = 'Homework Helpers Samples'
        product.save
      end

      product = Spree::Product.where(slug: 'the-wheatley-portfolio').first
      if product.present?
        product.meta_title = 'The Wheatley Portfolio'
        product.save
      end

      product = Spree::Product.where(slug: 'consejos-para-padres').first
      if product.present?
        product.meta_title = 'Consejos Para Padres'
        product.save
      end

      product = Spree::Product.where(slug: 'the-alexandria-plan').first
      if product.present?
        product.meta_title = 'The Alexandria Plan'
        product.save
      end

      product = Spree::Product.where(slug: 'consejos-para-la-familia-ww').first
      if product.present?
        product.meta_title = 'Consejos para la Familia'
        product.save
      end

      product = Spree::Product.where(slug: 'ela-standards-alignment-studies').first
      if product.present?
        product.meta_title = 'Standards Alignment Studies'
        product.save
      end

      product = Spree::Product.where(slug: 'state-standards-alignment-studies-science').first
      if product.present?
        product.meta_title = 'Standards Alignment Studies'
        product.save
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
