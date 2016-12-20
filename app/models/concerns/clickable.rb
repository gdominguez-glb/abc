module Clickable
  extend ActiveSupport::Concern

  def increase_clicks!
    update(clicks: self.clicks + 1)
  end
end
