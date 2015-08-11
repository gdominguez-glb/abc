require 'rails_helper'

RSpec.describe ProductTrack, type: :model do
  it { should belong_to(:user).class_name('Spree::User') }
  it { should belong_to(:product).class_name('Spree::Product') }
  it { should belong_to(:material).class_name('Spree::Material') }
end
