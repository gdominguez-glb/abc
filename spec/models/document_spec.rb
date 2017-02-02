require 'rails_helper'

RSpec.describe Document, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:category) }

  it_behaves_like "categorizable"

  before(:each) do
    allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
  end

  describe "taggable documents" do
    let(:document) { create(:document, tag_list: 'tag1') }

    it 'assign tag_list' do
      document.update(tag_list: 'tag1,tag2')
      expect(document.tags.map(&:name).sort).to eq(['tag1', 'tag2'])
    end

    it "search by tags" do
      expect(Document.tagged_with('tag1')).to eq([document])
    end
  end
end
