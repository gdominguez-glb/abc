namespace 'pages' do
  desc "Loading all default pages."
  task :load => :environment do
    pages_array.each do |params|
      next if page = Page.find_by(slug: params[:slug])
      page = Page.create(params)
      page.update_attributes(visible: true)

      puts "Page: slug='#{page.slug}'' was created."
    end
  end

  desc "[Don't do this if you don't know what this is!] Reset all default pages."
  task :reset => :environment do
    pages_from_yaml = ['home', 'careers', 'math', 'english', 'history', 'tos', 'about'].map do |pages_name|
      YAML.load_file(Rails.root.join("config/pages/#{pages_name}.yml"))['pages']
    end.flatten
    (pages_array + pages_from_yaml).each do |params|
      params.symbolize_keys!
      page = Page.where(slug: params[:slug]).first_or_create
      if params[:group_name].present? &&  curriculum = Curriculum.find_by(name: params[:group_name].titleize)
        params[:curriculum_id] = curriculum.id
      end
      page.update_attributes(params.merge(visible: true).merge((params[:tiles].blank? ? { tiles: nil } : {} )))

      puts "Page: slug='#{page.slug}'' was updated."
    end
  end

  # rake pages:reset_page section=about title=About
  desc "reset single page"
  task :reset_page => :environment do
    page_section = ENV['section']
    page_title   = ENV['title']
    pages_yaml = YAML.load_file(Rails.root.join("config/pages/#{page_section}.yml"))['pages']
    page_yaml = pages_yaml.find{|p| p['title'] == page_title }
    page_yaml.symbolize_keys!
    page = Page.where(slug: page_yaml[:slug]).first_or_create
    page.update_attributes(page_yaml.merge(visible: true).merge((page_yaml[:tiles].blank? ? { tiles: nil } : {} )))
  end
end

def pages_array
  pages_array = [
    {title: "Marketing Page Sample", seo_content: "Math Marketing Site, Update this area", slug: "math/curriculum", group_name: "math", sub_group_name: "curriculum", position: 6, body: "Math Marketing, Update this area", show_in_nav: false},

    {title: "Marketing Page Sample", seo_content: "English Marketing Site, Update this area", slug: "english/curriculum", group_name: "english", sub_group_name: "curriculum", position: 6, body: "English Marketing, Update this area", show_in_nav: false},

    {title: "Marketing Page Sample", seo_content: "History Marketing Site, Update this area", slug: "history/curriculum", group_name: "history", sub_group_name: "curriculum", position: 6, body: "History Marketing, Update this area", show_in_nav: false},

    {title: "About", seo_content: "About, Update this area", slug: "about", group_name: "about", sub_group_name: "", position: 1, body: "About, Update this area", show_in_nav: false, show_in_footer: true, group_root: true},
    {title: "Mission", seo_content: "Mission, Update this area", slug: "about/mission", group_name: "about", sub_group_name: "mission", position: 2, body: "Mission, Update this area", show_in_nav: false, show_in_footer: true},
    {title: "Staff", seo_content: "Staff, Update this area", slug: "about/staff", group_name: "about", sub_group_name: "mission", position: 3, body: "Mission, Update this area", show_in_nav: false, show_in_footer: true},
    {title: "Trustees", seo_content: "Trustees, Update this area", slug: "about/trustees", group_name: "about", sub_group_name: "mission", position: 4, body: "Mission, Update this area", show_in_nav: false, show_in_footer: true},
    {title: "Advocacy", seo_content: "Advocacy, Update this area", slug: "advocacy", group_name: "advocacy", sub_group_name: "", position: 6, body: "Advocacy, Update this area", show_in_nav: false, show_in_footer: true, group_root: true},

    {title: "Not Found", seo_content: "This is page for not found ", slug: "not-found", group_name: "general", sub_group_name: "not-found", position: 5, body: "Not Found Page, Update this area", show_in_nav: false}
  ]
end
