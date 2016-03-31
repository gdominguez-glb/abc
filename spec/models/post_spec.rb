require 'rails_helper'

RSpec.describe Post, type: :model do
  it { should belong_to(:medium_publication) }

  let(:post) { create(:post, medium_publication: create(:medium_publication), title: 'A', subtitle: 'a', body: 'post body') }

  describe "#should_index?" do
    it "index when medium publication is present" do
      expect(post.should_index?).to eq(true)
    end

    it "not index when medium publication is empty" do
      post.medium_publication = nil
      expect(post.should_index?).to eq(false)
    end
  end

  it "generate search data" do
    expect(post.search_data).to eq({
      title: 'A',
      subtitle: 'a',
      body: 'post body',
      user_ids: [-1]
    })
  end
end
