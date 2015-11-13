class SelectUsersForm
  include ActiveModel::Model
  attr_accessor :licenses_recipients, :emails, :users_file

  def perform
    all_emails
  end

  def all_emails
    @all_emails ||= (@licenses_recipients || '').split(',').map(&:strip) + (@emails||[]) + emails_in_file
  end

  def emails_in_file
    return [] if @users_file.blank?
    rows = case file_format
    when '.xlsx'
      parse_excel_rows
    when '.csv'
      parse_csv_rows
    else
      []
    end
    rows.map {|row| row[0] }
  end

  def file_format
    ext = File.extname(@users_file.original_filename).downcase
  end

  def parse_excel_rows
    xlsx   = Roo::Excelx.new(@users_file.path)
    sheet  = xlsx.sheet(0)
    header = sheet.row(1)
    (2..sheet.last_row).map do |i|
      Hash[[header, sheet.row(i)].transpose]
    end
  end

  def parse_csv_rows
    rows   = CSV.read(@users_file.path)
    header = rows[0]
    (1..(rows.length-1)).to_a.map do |i|
      Hash[[header, rows[i]].transpose]
    end
  end
end