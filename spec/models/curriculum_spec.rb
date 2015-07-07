require 'rails_helper'

RSpec.describe Curriculum, type: :model do
  it { should validate_presence_of(:name) }

  it { should have_many(:pages) }

  describe ".visibles" do
    it "return visible curriculum" do
      curriculum = create(:curriculum, visible: true)
      expect(Curriculum.visibles).to include(curriculum)
    end
  end
end
