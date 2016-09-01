require 'rails_helper'

RSpec.describe DocumentTagging, type: :model do
  it { should belong_to(:document) }
  it { should belong_to(:tag).class_name('DocumentTag') }
end
