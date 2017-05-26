namespace :vanity_urls do
  namespace :export do
    task csv: :environment do
      CSV.open("#{Rails.root}/tmp/vanity_urls.csv", "wb") do |csv|
        csv << ["Url", "Redirect Url"]
        vanitys = VanityUrl.where("url like '%eurmath.link%'")
        vanitys.find_each do |v|
          csv << [v.url, v.redirect_url]
        end
      end

      puts "Success..."
    end
  end
end