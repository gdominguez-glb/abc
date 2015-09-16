class Spree::LicenseDistributer
  def initialize(attrs={})
    @user       = attrs[:user]
    @file       = attrs[:file]
    @product_id = attrs[:product_id]

    @licensed_products = @user.licensed_products.distributable.available.where(product_id: @product_id).to_a
  end

  def distribute
    return { success: false, error: "Product can't be blank" } if @product_id.blank?
    return { success: false, error: "File can't be blank" } if @file.blank?
    license_rows = case file_format
    when '.xlsx'
      parse_excel_rows
    when '.csv'
      parse_csv_rows
    end
    return { success: false, error: "Invalid rows" } if license_rows.empty?
    return { success: false, error: "Invalid licenses number " } if !validate_license_quantity(license_rows)

    product = Spree::Product.find(@product_id)
    Spree::LicensesManager::LicensesDistributer.new(user: @user, product: product, rows: license_rows.map(&:symbolize_keys)).execute

    { success: true }
  end

  def file_format
    ext = File.extname(@file.original_filename).downcase
  end

  def parse_excel_rows
    xlsx   = Roo::Excelx.new(@file.path)
    sheet  = xlsx.sheet(0)
    header = sheet.row(1)
    (2..sheet.last_row).map do |i|
      Hash[[header, sheet.row(i)].transpose]
    end
  end

  def parse_csv_rows
    rows   = CSV.read(@file.path)
    header = rows[0]
    (1..(rows.length-1)).to_a.map do |i|
      Hash[[header, rows[i]].transpose]
    end
  end

  def validate_license_quantity(license_rows)
    total_quantity = license_rows.map{|row| row['quantity'].to_i || 0 }.sum
    return false if total_quantity == 0
    return false if total_quantity > @licensed_products.sum(&:quantity)
    true
  end

  def valid_header?(header)
    header.map(&:downcase) == ['email', 'quantity']
  end

end
