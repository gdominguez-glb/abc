require 'rails_helper'

RSpec.describe DownloadProduct, type: :model do
  it { should belong_to(:download_page) }
  it { should belong_to(:product).class_name('Spree::Product') }

  it { should validate_presence_of(:download_page) }
  it { should validate_presence_of(:product) }
end
