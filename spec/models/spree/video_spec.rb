require 'rails_helper'

RSpec.describe Spree::Video, type: :model do
  it { should belong_to(:product).class_name('Spree::Product') }

  it { should validate_presence_of(:title) }
end
