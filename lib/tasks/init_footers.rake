namespace :footers do
  desc "Reset all default footer links."
  task :reset => :environment do
    FooterTitle.destroy_all
    titles = [
      {
        title: 'About',
        link: '/about',
        sub_links: [
          { name: 'Contact', link: '/contact'},
          { name: 'Mission', link: '/about/mission' },
          { name: 'Staff', link: '/team' },
          { name: 'Trustees', link: '/team/trustees' }
        ]
      },
      {
        title: 'TOS',
        link: '/terms-of-service'
      },
      {
        title: 'FAQ',
        link: ''
      },
      {
        title: 'Careers',
        link: '/careers'
      }
    ]

    titles.each do |title_attrs|
      footer_title = FooterTitle.create(title: title_attrs[:title], link: title_attrs[:link])
      (title_attrs[:sub_links] || []).each do |link_attrs|
        footer_title.footer_links.create(name: link_attrs[:name], link: link_attrs[:link])
      end
    end
  end
end
