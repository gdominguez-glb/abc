class Spree::LicenseImporter
  def initialize(file)
    @file = file
  end

  def import
    xlsx   = Roo::Excelx.new(@file.path)
    sheet  = xlsx.sheet(0)
    header = sheet.row(1)
    return { error: 'Invalid excel header' } if !valid_header?(header)

    licensed_products = construct_records(header, sheet)
    return { error: 'Invalid product/quantity' } if !licensed_products.all?{|lp| lp.valid? }

    licensed_products.each{|lp| lp.save }
    return {}
  end

  def valid_header?(header)
    header.map(&:downcase) == ['email', 'product', 'quantity']
  end

  def construct_records(header, sheet)
    (2..sheet.last_row).map do |i|
      row = Hash[[header.map(&:downcase), sheet.row(i)].transpose]
      product = Spree::Product.find_by name: row['product']
      Spree::LicensedProduct.new(
        email: row['email'],
        product: product,
        quantity: row['quantity']
      )
    end
  end
end
