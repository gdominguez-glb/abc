FactoryBot.define do
  factory :material_import_job, class: 'Spree::MaterialImportJob' do
    user_id { 1 }
    product_id { 1 }
  end

end
