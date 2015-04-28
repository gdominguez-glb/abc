module Spree
  class Curriculum < ActiveRecord::Base
    acts_as_paranoid
    acts_as_list

    validates :name, presence: true, uniqueness: { scope: :deleted_at }
  end
end
