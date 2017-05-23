class InTheNew < ActiveRecord::Base
  include Orderable

  validates :title, presence: true
end
