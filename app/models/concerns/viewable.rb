module Viewable
  extend ActiveSupport::Concern

  def increase_views!
    update(views: self.views + 1)
  end
end
