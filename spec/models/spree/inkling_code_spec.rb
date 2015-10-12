require 'rails_helper'

RSpec.describe Spree::InklingCode, type: :model do
  it { should belong_to(:product).class_name('Spree::Product') }
end
