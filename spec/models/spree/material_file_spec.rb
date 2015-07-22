require 'rails_helper'

RSpec.describe Spree::MaterialFile, type: :model do
  it { should belong_to(:material).class_name('Spree::Material') }
end
