module Spree
  class GradeUnit < Spree::Base
    acts_as_paranoid
    acts_as_list

    validates :name, presence: true, uniqueness: { scope: [:grade_id, :deleted_at], allow_blank: true }
    belongs_to :grade, class_name: 'Spree::Grade'
  end
end
