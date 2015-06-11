class Recommendation < ActiveRecord::Base
  validates_presence_of :title, :sub_header, :call_to_action_button_text, :call_to_action_button_link

  has_attached_file :photo
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
end
