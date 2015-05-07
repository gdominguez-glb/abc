class ContactController < ApplicationController
  def index
    @topics = ContactTopic.order('position asc').map(&:name)
  end
end
