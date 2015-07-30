require 'rails_helper'

RSpec.describe Spree::Material, type: :model do
  it { should belong_to(:product).class_name('Spree::Product') }
  it { should have_many(:material_files) }
end