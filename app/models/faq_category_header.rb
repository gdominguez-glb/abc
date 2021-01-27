class FaqCategoryHeader < ApplicationRecord
  has_many :faq_categories, -> { order("position") }

  before_destroy :update_faq_categories

  def update_faq_categories
    faq_categories.update_all(faq_category_header_id: nil)
  end

  class << self
    def list_all(displayable = nil)
      headers = self.all.order(:position).to_a
      headers_no_mapped = FaqCategory.order(:position).where(faq_category_header_id: nil)
      headers_no_mapped = headers_no_mapped.where(display: displayable) unless displayable.nil?

      s = Struct.new(:name, :faq_categories).new(nil, headers_no_mapped)
      headers.push(s)
      headers
    end
  end
end
