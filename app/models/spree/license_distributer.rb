class Spree::LicenseDistributer
  def initialize(user, file)
    @user = user
    @file = file
  end

  def distribute
    xlsx   = Roo::Excelx.new(@file.path)
    sheet  = xlsx.sheet(0)
    header = sheet.row(1)
    license_rows = (2..sheet.last_row).map do |i|
      Hash[[header, sheet.row(i)].transpose]
    end
    return false if !validate_license_quantity(license_rows)
    distribute_licenses(license_rows)
  end

  def distribute_licenses(license_rows)
    records = license_rows.map do |row|
      construct_distribution(row)
    end
    Spree::ProductDistribution.transation do
      records.each{|r| r.save }
    end
  end

  def construct_distribution(row)
    to_user = User.find_by(email: row['email'])
    email = to_user ? nil : row['email']
    Spree::ProductDistribution.new(
      from_user: @user,
      product_id: row['product_id'],
      quantity: row['quantity'],
      to_user: to_user,
      email: email
    )
  end

  def validate_license_quantity(license_rows)
    products_quantity = license_rows.inject({}) {|result, row| result[row['product_id']] = (result[row['product_id']] || 0) + row['quantity'].to_i; result }
    products_quantity.each do |product_id, quantity|
      return false if quantity > @user.licensed_products.available.where(product_id: product_id).sum(:quantity)
    end
    true
  end

  def valid_header?(header)
    header.map(&:downcase) == ['email', 'product_id', 'quantity']
  end
end