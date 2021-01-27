class WhatsNew < ApplicationRecord

  include Clickable, DashboardFilterable, Displayable, Orderable, Viewable
  has_and_belongs_to_many :products, class_name: 'Spree::Product', join_table: 'products_whats_news'
  validates :title, presence: true
  validates :sub_header, length: {maximum: 168}

end
