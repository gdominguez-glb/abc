class AddFaqCategoryHeaderToFaqCategory < ActiveRecord::Migration
  def change
    add_reference :faq_categories, :faq_category_header
  end
end
