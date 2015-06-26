class Spree::LicenseImporter
  def initialize(file)
    @file = file
  end

  def import
    xlsx   = Roo::Excelx.new(@file.path)
    sheet  = xlsx.sheet(0)
    header = sheet.row(1)
    return false if !valid_header?(header)

    licensed_products = construct_records(header, sheet)
    return false if !licensed_products.all?{|lp| lp.valid? }

    licensed_products.each{|lp| lp.save }
  end

  def valid_header?(header)
    header.map(&:downcase) == ['email', 'product_id', 'quantity']
  end

  def construct_records(header, sheet)
    (2..sheet.last_row).map do |i|
      row = Hash[[header, sheet.row(i)].transpose]
      Spree::LicensedProduct.new(row)
    end
  end
end
