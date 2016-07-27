class CustomIndexPage

  include ActiveModel::Model

  attr_accessor :title, :description, :feature, :id, :url

  searchkick callbacks: false

  def self.all
    CustomIndexArray.new([
      CustomIndexPage.new(title: 'Meet the Team', description: 'Team staff trustees', feature: 'team', id: 'team_page', url: '/team')
    ])
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
