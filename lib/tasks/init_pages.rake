namespace 'pages' do
  desc "Loading all default pages."
  task :load => :environment do
    pages_array.each do |params|
      next if page = Page.find_by(slug: params[:slug])
      page = Page.create(params)

      puts "Page: slug='#{page.slug}'' was created."
    end
  end

  desc "[Don't do this if you don't know what this is!] Reset all default pages."
  task :reset => :environment do
    pages_array.each do |params|
      page = Page.where(slug: params[:slug]).first_or_create
      page.update_attributes(params)

      puts "Page: slug='#{page.slug}'' was updated."
    end
  end
end

def pages_array
  pages_array = [
    {title: "Math Overview", seo_content: "Math, Update this area", slug: "math", group_name: "math", sub_group_name: "overview", position: 1, body: "Math Overview, Update this area", group_root: true},
    {title: "Math Admins", seo_content: "Math Admins, Update this area", slug: "math/admins", group_name: "math", sub_group_name: "admins", position: 2, body: "Math Overview, Update this area"},
    {title: "Math Teathers", seo_content: "Math Teathers, Update this area", slug: "math/teachers", group_name: "math", sub_group_name: "teachers", position: 3, body: "Math Admins, Update this area"},
    {title: "Math Parents ", seo_content: "Math Parents, Update this area", slug: "math/parents", group_name: "math", sub_group_name: "parents", position: 4, body: "Math Parents, Update this area"},
    {title: "Math Eurehka Shop", seo_content: "Math Eurehka Shop, Update this area", slug: "math/eureka-shop", group_name: "math", sub_group_name: "eureka-shop", position: 5, body: "Math Eureka Shop, Update this area"},
    {title: "Math Marketing Page Sample", seo_content: "Math Marketing Site, Update this area", slug: "math/curriculum", group_name: "math", sub_group_name: "curriculum", position: 6, body: "Math Marketing, Update this area", show_in_nav: false},

    {title: "English Overview", seo_content: "English, Update this area", slug: "english", group_name: "english", sub_group_name: "overview", position: 1, body: "English Overview, Update this area", group_root: true},
    {title: "English Admins", seo_content: "English Admins, Update this area", slug: "english/admins", group_name: "english", sub_group_name: "admins", position: 2, body: "English Overview, Update this area"},
    {title: "English Teathers", seo_content: "English Teathers, Update this area", slug: "english/teachers", group_name: "english", sub_group_name: "teachers", position: 3, body: "English Admins, Update this area"},
    {title: "English Parents ", seo_content: "English Parents, Update this area", slug: "english/parents", group_name: "english", sub_group_name: "parents", position: 4, body: "English Parents, Update this area"},
    {title: "English Eurehka Shop", seo_content: "English Eurehka Shop, Update this area", slug: "english/wheatley-shop", group_name: "english", sub_group_name: "wheatley-shop", position: 5, body: "English Wheatley Shop, Update this area"},
    {title: "English Marketing Page Sample", seo_content: "English Marketing Site, Update this area", slug: "english/curriculum", group_name: "english", sub_group_name: "curriculum", position: 6, body: "English Marketing, Update this area", show_in_nav: false},

    {title: "History Overview", seo_content: "History, Update this area", slug: "history", group_name: "history", sub_group_name: "overview", position: 1, body: "History Overview, Update this area", group_root: true},
    {title: "History Admins", seo_content: "History Admins, Update this area", slug: "history/admins", group_name: "history", sub_group_name: "admins", position: 2, body: "History Overview, Update this area"},
    {title: "History Teathers", seo_content: "History Teathers, Update this area", slug: "history/teachers", group_name: "history", sub_group_name: "teachers", position: 3, body: "History Admins, Update this area"},
    {title: "History Parents ", seo_content: "History Parents, Update this area", slug: "history/parents", group_name: "history", sub_group_name: "parents", position: 4, body: "History Parents, Update this area"},
    {title: "History Alexandria Shop", seo_content: "History Alexandria Shop, Update this area", slug: "history/eureka-shop", group_name: "history", sub_group_name: "alexandria-shop", position: 5, body: "History Eureka Shop, Update this area"},
    {title: "History Marketing Page Sample", seo_content: "History Marketing Site, Update this area", slug: "history/curriculum", group_name: "history", sub_group_name: "curriculum", position: 6, body: "History Marketing, Update this area", show_in_nav: false},

    {title: "About", seo_content: "About, Update this area", slug: "about", group_name: "general", sub_group_name: "about", position: 1, body: "About, Update this area", show_in_nav: false, show_in_footer: true},
    {title: "Careers", seo_content: "Career, Update this area", slug: "careers", group_name: "general", sub_group_name: "careers", position: 2, body: "Career Overview, Update this area", show_in_nav: false, show_in_footer: true},
    {title: "Advocacy", seo_content: "Advocacy, Update this area", slug: "advocacy", group_name: "general", sub_group_name: "advocacy", position: 3, body: "Advocacy, Update this area", show_in_nav: false},
    {title: "Terms of Service", seo_content: "CarTerms of Serviceeer, Update this area", slug: "terms-of-service", group_name: "general", sub_group_name: "terms-of-service", position: 4, body: "Terms of service Overview, Update this area", show_in_nav: false, show_in_footer: true},
    {title: "Not Found", seo_content: "This is page for not found ", slug: "not-found", group_name: "general", sub_group_name: "not-found", position: 5, body: "Not Found Page, Update this area", show_in_nav: false}
  ]
end
