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
          { name: 'Staff', link: '/staffs' },
          { name: 'Trustees', link: '/staffs/trustees' }
        ]
      },
      {
        title: 'TOS',
        link: '/terms-of-service'
      },
      {
        title: 'Updates',
        link: '',
        sub_links: [
          { name: 'Press', link: '/blog/global/press' },
          { name: 'Reports', link: '/blog/global/reports' }
        ]
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
