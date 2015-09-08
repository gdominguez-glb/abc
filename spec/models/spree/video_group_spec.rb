require 'rails_helper'

RSpec.describe Spree::VideoGroup, type: :model do
  it { should have_many(:videos).class_name('Spree::Video') }
  it { should have_many(:products).class_name('Spree::Product') }
end
