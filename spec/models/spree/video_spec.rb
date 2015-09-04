require 'rails_helper'

RSpec.describe Spree::Video, type: :model do
  it { should belong_to(:video_group).class_name('Spree::VideoGroup') }

  it { should validate_presence_of(:title) }
end
