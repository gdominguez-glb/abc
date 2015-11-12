require 'rails_helper'

RSpec.describe Activity, type: :model do
  it { should belong_to(:user).class_name('Spree::User') }
  it { should belong_to(:item) }
end
