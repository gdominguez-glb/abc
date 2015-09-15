class Spree::LicenseImporter
  def initialize(file)
    @file = file
  end

  def import
    xlsx   = Roo::Excelx.new(@file.path)
    sheet  = xlsx.sheet(0)
    header = sheet.row(1).map(&:downcase)

    return { success: false, error: 'Invalid excel header' } if !valid_header?(header)

    rows = build_rows(sheet, header)

    return { success: false, error: 'Invalid product/quantity' } if !valid_product_quantity?(rows)

    Spree::LicensesManager::LicensesCreator.new(rows).execute

    return { success: true }
  end

  def valid_header?(header)
    header == ['email', 'product', 'quantity']
  end

  def valid_product_quantity?(rows)
    !rows.select{ |row| row[:product].blank? || (row[:quantity] == 0)  }.any?
  end

  def build_rows(sheet, header)
    (2..sheet.last_row).map do |i|
      row = generate_row_hash(header, sheet.row(i))

      {
        email:    row['email'],
        product:  Spree::Product.find_by(name: row['product']),
        quantity: row['quantity'].to_i
      }
    end
  end

  def generate_row_hash(header, raw_row)
    Hash[[header, raw_row].transpose]
  end
end
