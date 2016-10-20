require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:faq_category) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:faq_category) }

  let(:question) { create(:question) }

  describe "#should_index?" do
    it "index question when displayable" do
      question.display = true
      expect(question.should_index?).to eq(true)
    end

    it "not index question when not displayable" do
      question.display = false
      expect(question.should_index?).to eq(false)
    end
  end

  describe "#search_data" do
    it "return data for index" do
      question = create(:question, title: 'FAQ Title', answer: create(:answer, content: 'FAQ Content'))
      expect(question.search_data).to eq({:title=>"FAQ Title", :content=>"FAQ Content", :user_ids=>[-1]})
    end
  end
end
