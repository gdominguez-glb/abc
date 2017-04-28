class FaqCategoryHeader < ActiveRecord::Base
  has_many :faq_categories

  before_destroy :update_faq_categories

  def update_faq_categories
    faq_categories.update_all(faq_category_header_id: nil)
  end

  class << self
    def list_all(displayable = false)
      headers = self.all.order(:position).to_a
      headers_no_mapped = FaqCategory.all.order(:position).where(faq_category_header_id: nil).where(display: displayable)
      s = Struct.new(:name, :faq_categories).new(nil, headers_no_mapped)
      headers.push(s)
      headers
    end
  end
end
