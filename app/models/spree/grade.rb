module Spree
  class Grade < Spree::Base
    acts_as_paranoid
    acts_as_list

    has_many :grade_units, class_name: 'Spree::GradeUnit', dependent: :delete_all, inverse_of: :grade

    validates :name, presence: true, uniqueness: { scope: :deleted_at }
    validates :abbr, presence: true, uniqueness: { scope: :deleted_at }
  end
end
