require 'rails_helper'

RSpec.describe Job, type: :model do
  let(:job) { create(:job) }

  describe "#should_index?" do
    it "return true when job is displayable" do
      job.display = true
      expect(job.should_index?).to eq(true)
    end

    it "return false when job is not displayable" do
      job.display = false
      expect(job.should_index?).to eq(false)
    end
  end
end
