require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:faq_category) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:faq_category) }
end
