require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:medium_publication) }
end
