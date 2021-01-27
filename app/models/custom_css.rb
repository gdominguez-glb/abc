class CustomCss < ApplicationRecord
  belongs_to :page

  enum custom_type: { global_css: 0, page_css: 1 }

  validates_presence_of :name, :content
  validates_presence_of :page_id, if: ->(cc) { cc.page_css? }
end
