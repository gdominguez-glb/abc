require 'rails_helper'

RSpec.describe Spree::VideoGroup, type: :model do
  it { should have_many(:videos).class_name('Spree::Video') }
  it { should have_many(:products).class_name('Spree::Product') }

  it "create taxon with video group name" do
    video_group = create(:spree_video_group, name: 'Teach Eureka')
    expect(Spree::Taxon.find_by(name: 'Teach Eureka')).not_to be_nil
  end
end
