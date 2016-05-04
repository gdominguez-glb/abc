namespace :beta do
  def convert_urls_in_tiles(tiles)
    rows = tiles[:rows]
    rows.each do |row|
      row.keys.select{|k| k =~ /link/ }.each do |key|
        if row[key] && row[key].include?('beta.greatminds.org')
          changed = true
          row[key] = row[key].gsub('beta.greatminds.org', 'greatminds.org')
        end
      end
    end
    { rows: rows }
  end

  desc "change beta link to greatminds.org"
  task change_links: :environment do
    Page.find_each do |page|
      page.update(tiles: convert_urls_in_tiles(page.tiles)) if page.tiles.present?
    end
    Spree::Product.find_each do |product|
      product.update(
        access_url: product.access_url.gsub('beta.greatminds.org', 'greatminds.org')
      ) if product.access_url.present? && product.access_url.include?('beta.greatminds.org')
    end
  end

end
