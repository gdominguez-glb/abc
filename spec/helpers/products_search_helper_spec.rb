require "rails_helper"

RSpec.describe ProductsSearchHelper, type: :helper do

  describe '#clear_preference_filters' do
    it 'should clean session: filter_role' do
      session[:filter_role] = 'value'
      clear_preference_filters
      expect(session[:filter_role]).to be_nil
    end

    it 'should clean session: filter_curriculum' do
      session[:filter_curriculum] = 'value'
      clear_preference_filters
      expect(session[:filter_curriculum]).to be_nil
    end
  end

end