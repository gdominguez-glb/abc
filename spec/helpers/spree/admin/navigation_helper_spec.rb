require "rails_helper"

RSpec.describe Spree::Admin::NavigationHelper, type: :helper do

  describe "#main_part_classes" do
    context "sidebar minimized" do
      it "return full column width" do
        cookies['sidebar-minimized'] = 'true'
        expect(helper.main_part_classes).to eq('col-sm-12 col-md-12')
      end
    end

    context "sidebar opened" do
      it "return part column width" do
        cookies['sidebar-minimized'] = nil
        expect(helper.main_part_classes).to eq('col-sm-9 col-md-10')
      end
    end
  end
end
