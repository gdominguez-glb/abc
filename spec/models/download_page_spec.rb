require 'rails_helper'

RSpec.describe DownloadPage, type: :model do
  it { should have_many(:download_products) }
  it { should have_many(:products).through(:download_products) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:slug) }
  it { should validate_uniqueness_of(:slug) }
end
