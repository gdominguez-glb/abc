namespace :mafis do
  desc "import products from csv"
  task import: :environment do
    csv_file = ENV['csv']
    if File.exists?(csv_file)
      CSV.foreach(csv_file, headers: true) do |row|
        next if row['RecordId'].blank?
        mafis_product = MafisProduct.find_or_initialize_by(record_id: row['RecordId'])
        mafis_product.update({name: row['Product Name'], image: row['Image URL'], small_description: row['Product Description'], description: row['Extended Product Description'], price: row['Price'].split(/\t/).last.strip, grade: row['Grade'], isbn: row['ISBN']})
        puts "Imported: #{mafis_product.record_id}"
      end
    else
      puts "Can't find file #{csv_file}"
    end
  end
end
