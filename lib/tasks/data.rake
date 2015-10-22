namespace :data do
  desc "clear users data"
  task clear: :environment do
    SchoolDistrict.delete_all
    NotificationTrigger.delete_all
    Notification.delete_all
    ProductTrack.delete_all

    Spree::User.delete_all
    Spree::Product.delete_all
    Spree::Variant.delete_all
    Spree::ProductAgreement.delete_all
    Spree::ProductDistribution.delete_all
    Spree::Address.delete_all
    Spree::Bookmark.delete_all
    Spree::CreditCard.delete_all
    Spree::Digital.delete_all
    Spree::DigitalLink.delete_all
    Spree::Grade.delete_all
    Spree::GradeUnit.delete_all
    Spree::InklingCode.delete_all
    Spree::InventoryUnit.delete_all
    Spree::LicensedProduct.delete_all
    Spree::LineItem.delete_all
    Spree::LogEntry.delete_all
    Spree::MaterialFile.delete_all
    Spree::MaterialImportJob.delete_all
    Spree::Material.delete_all
    Spree::Order.delete_all
    Spree::Part.delete_all
    Spree::PaymentCaptureEvent.delete_all
    Spree::Payment.delete_all
    Spree::Price.delete_all
    ActiveRecord::Base.connection.execute("delete from spree_products_taxons")
    Spree::PurchaseOrder.delete_all
    Spree::Shipment.delete_all
    ActiveRecord::Base.connection.execute("delete from spree_taxons_videos")
    Spree::VideoGroup.delete_all
    Spree::Video.delete_all

    SalesforceReference.delete_all

    Activity.delete_all
  end
end
