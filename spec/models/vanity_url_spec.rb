require 'rails_helper'

RSpec.describe VanityUrl, type: :model do
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:redirect_url) }
end
