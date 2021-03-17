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
      p = Spree::Product.where(slug: 'eureka-parent-tip-sheets').first
      p.meta_title = 'Family Tip Sheets'
      p.save

      p = Spree::Product.where(slug: 'eureka-digital-suite-group').first
      p.meta_title = 'Eureka Digital Suite'
      p.save

      p = Spree::Product.where(slug: 'wit-wisdom-assessment-resources').first
      p.meta_title = 'Assessment Resources'
      p.save

      p = Spree::Product.where(slug: 'state-alignment-studies').first
      p.meta_title = 'State Alignment Studies'
      p.save

      p = Spree::Product.where(slug: 'wit-wisdom-family-tip-sheets').first
      p.meta_title = 'Family Tip Sheets'
      p.save

      p = Spree::Product.where(slug: 'eureka-spanish-grade-roadmaps').first
      p.meta_title = 'Spanish Grade Roadmaps'
      p.save

      p = Spree::Product.where(slug: 'copy-of-homework-helpers-samples').first
      p.meta_title = 'Homework Helpers Samples'
      p.save

      p = Spree::Product.where(slug: 'the-wheatley-portfolio').first
      p.meta_title = 'The Wheatley Portfolio'
      p.save

      p = Spree::Product.where(slug: 'consejos-para-padres').first
      p.meta_title = 'Consejos Para Padres'
      p.save

      p = Spree::Product.where(slug: 'the-alexandria-plan').first
      p.meta_title = 'The Alexandria Plan'
      p.save

      p = Spree::Product.where(slug: 'consejos-para-la-familia-ww').first
      p.meta_title = 'Consejos para la Familia'
      p.save

      p = Spree::Product.where(slug: 'ela-standards-alignment-studies').first
      p.meta_title = 'Standards Alignment Studies'
      p.save

      p = Spree::Product.where(slug: 'state-standards-alignment-studies-science').first
      p.meta_title = 'Standards Alignment Studies'
      p.save
    end
  end
end
