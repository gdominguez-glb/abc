require 'rails_helper'

RSpec.describe EventPage, type: :model do
  it { should belong_to(:page) }
end
