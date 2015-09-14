class AddFaqCategoryIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :faq_category_id, :integer
  end
end
