require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#store_active_class" do
    it "return active for url that start with store" do
      controller.request.path = '/store/products'

      expect(helper.store_active_class).to eq('active')
    end

    it "return empty in login page" do
      controller.request.path = '/store/login'

      expect(helper.store_active_class).to eq('')
    end

    it "return empty for url that outside of store" do
      controller.request.path = '/page/123'

      expect(helper.store_active_class).to eq('')
    end
  end
end
