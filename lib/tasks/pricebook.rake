namespace :pricebook do
  desc "Prepare products for pricebook switch"
  task prepare_products: :environment do
    # copy products (call product.duplicate)
    # copy group items
    # copy bundles/parts
    # append internal name (2017/18)
    # do not duplicate pricebook id
    # do not show or available
    # duplicate inkling code
    # grades, spree_parts, spree_group_items

    puts "Last product id before duplicate: #{Spree::Product.last.id}"

    Spree::Product.transaction do

      products = Spree::Product.all.to_a

      # Spree::ProductDuplicator.clone_images_default = false

      products.each do |product|
        puts "Duplicating: #{product.id} #{product.name}"
        new_product = product.duplicate
        new_product.name = product.name
        new_product.internal_name = "#{product.name} (2017/18)"
        new_product.show_in_storefront = false
        new_product.for_sale = false
        new_product.price = product.price
        new_product.save(validate: false)
      end

      Spree::Part.all.to_a.each do |part|
        next if part.bundle.blank? || part.product.blank?
        new_bundle = Spree::Product.find_by(name: "#{part.bundle.name} (2017/18)")
        new_product = Spree::Product.find_by(name: "#{part.product.name} (2017/18)")
        Spree::Part.create(bundle: new_bundle, product: new_product) if new_bundle && new_product
      end

      Spree::GroupItem.all.to_a.each do |group_item|
        next if group_item.group.blank? || group_item.product.blank?
        new_group = Spree::Product.find_by(name: "#{group_item.group.name} (2017/18)")
        new_product = Spree::Product.find_by(name: "#{group_item.product.name} (2017/18)")
        Spree::GroupItem.create(group: new_group, product: new_product, position: group_item.position) if new_group && new_product
      end

    end

  end
end
