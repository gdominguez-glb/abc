class SyncInklingIdsWorker
  include Sidekiq::Worker

  def perform
    user = Spree::User.find_by(email: 'web.admin@greatminds.net')
    raise "Super user web.admin@greatminds.net not exists" if user.nil?
    inkling_products = Spree::Product.where(product_type: 'inkling_connect').where.not(inkling_id: ['', nil])
    mapping = inkling_products.inject({}){|m, product| m[product.inkling_id] = '1'; m }
    user_csv = Inkling::CsvGenerator.generate_from_user_mapping(user, mapping)
    file_path = Inkling.generate_csv_file(user, user_csv)
    Inkling::SftpUploader.upload_and_rename(file_path)
  end
end
