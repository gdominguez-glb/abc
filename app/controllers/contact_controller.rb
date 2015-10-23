class ContactController < ApplicationController

  def index
    @contact_form = ContactForm.new

    @topics = ["General", "Print or Bulk Orders", "Sales and Purchasing", "Professional Development", "Support"]
    @supports = ["Order Support", "Parent Support", "Content/Implementation Support", "Content Error", "Technical Support"]
  end
end
