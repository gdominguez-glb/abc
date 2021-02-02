class Post < ApplicationRecord
  belongs_to :medium_publication

  include FriendlyId
  friendly_id :title, use: :slugged

  searchkick callbacks: :async

  def should_index?
    medium_publication.present?
  end

  def search_data
    {
      title: title,
      subtitle: subtitle,
      body: body,
      user_ids: [-1]
    }
  end
end
