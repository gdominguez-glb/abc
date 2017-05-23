namespace :vanity_urls do
  namespace :export do
    task csv: :environment do
      category = ENV['category'] || nil
      CSV.open("#{Rails.root}/tmp/vanity_urls.csv", "wb") do |csv|
        csv << ["Url", "Redirect Url"]
        vanitys = VanityUrl.all
        vanitys = vanitys.where(category: category.titleize) unless category.nil?
        vanitys.find_each do |v|
          csv << [v.url, v.redirect_url]
        end
      end

      puts "Success..."
    end
  end
end