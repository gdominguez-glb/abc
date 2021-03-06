require 'rails_helper'

RSpec.describe WhatsNew, type: :model do

  it { should validate_presence_of :title }
  it { should validate_length_of(:sub_header).is_at_most(168) }

  let(:whats_new) { FactoryBot.create(:whats_new) }

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
      it 'should return displayed whats_news' do
        FactoryBot.create_list(:whats_new, 3, display: true)
        FactoryBot.create_list(:whats_new, 2, display: false)
        expect(WhatsNew.displayable.count).to eq(3)
      end
    end

    context '#orderable' do
      it 'should return latest whats_news' do
        whats_new
        FactoryBot.create(:whats_new, created_at: 10.minutes.ago)
        expect(WhatsNew.latest.first).to eq(whats_new)
      end
    end
  end

end
