module Importers
  class Product
    # SELECT
    #   ct.entry_id as entry_id,
    #   ct.title as title,
    #   ct.url_title as slug,
    #   ct.status as status,
    #   ct.entry_date as created_at,
    #   cd.field_id_79 as price
    # FROM 
    #   exp_channel_titles as ct 
    # JOIN 
    #   exp_channel_data as cd 
    # ON 
    #   cd.entry_id = ct.entry_id
    # WHERE
    #   ct.channel_id = 35
    def self.import
      shipping_category = Spree::ShippingCategory.find_by(name: 'Digital Delivery')

      Migrate::ChannelTitle.select([
        'exp_channel_titles.entry_id as entry_id',
        'exp_channel_titles.title as title',
        'exp_channel_titles.url_title as slug',
        'exp_channel_titles.status as status',
        'exp_channel_titles.entry_date as entry_date',
        'exp_channel_data.field_id_79 as price'
      ]).joins("join exp_channel_data on exp_channel_data.entry_id = exp_channel_titles.entry_id")
        .where("exp_channel_titles.channel_id in (?)", [25, 57])
        .find_each do |product_data|
          unless Spree::Product.find_by(slug: product_data.slug)
            Spree::Product.create(
              name: product_data.title,
              slug: product_data.slug,
              shipping_category: shipping_category,
              price: product_data.price
            )
          end
      end
    end
  end
end
