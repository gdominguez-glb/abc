require 'rails_helper'

RSpec.describe WhatsNew, type: :model do

  it { should validate_presence_of :title }

  let(:whats_new) { FactoryGirl.create(:whats_new) }

  describe '#concerns' do
    context '#clickable' do
      it 'should increase clicks' do
        whats_new.increase_clicks!
        expect(whats_new.clicks).to eq(1)
      end
    end

    context '#viewable' do
      it 'should increase views' do
        whats_new.increase_views!
        expect(whats_new.views).to eq(1)
      end
    end

    context '#displayable' do
      it 'should return displayed recommendations' do
        FactoryGirl.create_list(:whats_new, 3, display: true)
        FactoryGirl.create_list(:whats_new, 2, display: false)
        expect(WhatsNew.displayable.count).to eq(3)
      end
    end
  end

end
