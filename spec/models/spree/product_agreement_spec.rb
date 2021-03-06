require 'rails_helper'

RSpec.describe Spree::ProductAgreement, type: :model do
  it { should belong_to(:product).class_name('Spree::Product') }
  it { should belong_to(:user).class_name('Spree::User') }
end
