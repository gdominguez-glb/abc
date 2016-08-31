require 'rails_helper'

RSpec.describe Spree::LibraryItem, type: :model do
  it { should belong_to(:library_leaf).class_name('Spree::LibraryLeaf') }
  it { should validate_presence_of(:name) }
end
