class Spree::LicenseImporter
  def initialize(file)
    @file = file
  end

  def import
    xlsx   = Roo::Excelx.new(@file.path)
    sheet  = xlsx.sheet(0)
    header = sheet.row(1)
    return { success: false, error: 'Invalid excel header' } if !valid_header?(header)

    licensed_products = construct_records(header, sheet)
    return { success: false, error: 'Invalid product/quantity' } if !licensed_products.all?{|lp| lp.valid? }

    licensed_products.each{|lp| lp.save }

    distribute_licenses_to_school_admin(licensed_products)

    return { success: true }
  end

  def valid_header?(header)
    header.map(&:downcase) == ['email', 'product', 'quantity']
  end

  def construct_records(header, sheet)
    (2..sheet.last_row).map do |i|
      row      = Hash[[header.map(&:downcase), sheet.row(i)].transpose]
      product  = Spree::Product.find_by(name: row['product'])
      quantity = row['quantity'].to_i

      licensed_product = Spree::LicensedProduct.new(
        email: row['email'],
        product: product,
        quantity: quantity,
        can_be_distributed: (quantity > 1 ? true : false)
      )
    end
  end

  def distribute_licenses_to_school_admin(licensed_products)
    licensed_products.select{|lp| lp.quantity > 1 }.each do |licensed_product|
      Spree::ProductDistribution.create(
        from_user:           licensed_product.user,
        from_email:          licensed_product.email,
        product_id:          licensed_product.product.id,
        to_user:             licensed_product.user,
        email:               licensed_product.email,
        licensed_product_id: licensed_product.product.id,
        quantity:            1,
        can_be_distributed:  false
      )
    end
  end
end
