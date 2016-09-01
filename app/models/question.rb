class Question < ActiveRecord::Base
  belongs_to :faq_category

  has_one :answer

  delegate :content, to: :answer, allow_nil: true

  scope :displayable, ->{ where(display: true) }

  accepts_nested_attributes_for :answer

  validates_presence_of :title, :faq_category

  searchkick callbacks: :async, personalize: "user_ids"

  def should_index?
    display?
  end

  def search_data
    {
      title: title,
      content: content,
      user_ids: [-1]
    }
  end

end
