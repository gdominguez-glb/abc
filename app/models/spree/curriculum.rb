module Spree
  class Curriculum < ApplicationRecord
    acts_as_paranoid
    acts_as_list

    validates :name, presence: true, uniqueness: { scope: :deleted_at }
  end
end
