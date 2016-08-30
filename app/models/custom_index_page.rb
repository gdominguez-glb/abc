class CustomIndexPage

  include ActiveModel::Model

  attr_accessor :title, :description, :feature, :id, :url

  searchkick callbacks: false

  def self.all
    CustomIndexArray.new([
      CustomIndexPage.new(title: 'Meet the Team', description: "Team staff #{build_team_content}", feature: 'team', id: 'team_page', url: '/team'),
      CustomIndexPage.new(title: 'Meet the trustees', description: "Team trustees #{build_team_trustees_content}", feature: 'team', id: 'team_trustees_page', url: '/team/trustees'),
      CustomIndexPage.new(title: 'Join the great minds team', description: "Jobs careers #{build_careers_content}", feature: 'careers', id: 'jobs', url: '/careers')
    ])
  end

  def self.build_team_content
    Staff.staff.map{|staff| "#{staff.name}-#{staff.title}"}.join(' ')
  end

  def self.build_team_trustees_content
    Staff.trustee.map{|staff| "#{staff.name}-#{staff.title}"}.join(' ')
  end

  def self.build_careers_content
    "We're looking to fill the following positions on our Great Minds team. Click below to find out more. Great Minds is an Equal Opportunity Employer.  #{Job.all.map(&:title).join(' ')}"
  end

  def search_data
    {
      title: title,
      description: description,
      feature: feature,
      user_ids: [-1]
    }
  end


  class CustomIndexArray < Array
    def for_ids(_ids)
      CustomIndexPage.all.select{|page| _ids.include?(page.id)}
    end
  end
end
