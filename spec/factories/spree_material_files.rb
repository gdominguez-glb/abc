FactoryBot.define do
  factory :spree_material_file, :class => 'Spree::MaterialFile' do
    material_id { 1 }
    file { "" }
  end

end
