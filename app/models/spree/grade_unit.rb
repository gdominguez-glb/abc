module Spree
  class GradeUnit < Spree::Base
    acts_as_paranoid

    validates :name, presence: true, uniqueness: { scope: [:grade_id, :deleted_at], allow_blank: true }
    belongs_to :grade, class_name: 'Spree::Grade'

    acts_as_list scope: :grade_id
  end
end
