require 'rails_helper'

RSpec.describe WhatNew, type: :model do
  it { should validate_presence_of :title }

  let(:what_new) { FactoryGirl.create(:what_new) }

  describe '#concerns' do
    context '#clickable' do
      it 'should increase clicks' do
        what_new.increase_clicks!
        expect(what_new.clicks).to eq(1)
      end
    end

    context '#viewable' do
      it 'should increase views' do
        what_new.increase_views!
        expect(what_new.views).to eq(1)
      end
    end

    context '#displayable' do
      it 'should return displayed recommendations' do
        FactoryGirl.create_list(:what_new, 3, display: true)
        FactoryGirl.create_list(:what_new, 2, display: false)
        expect(WhatNew.displayable.count).to eq(3)
      end
    end
  end
end
