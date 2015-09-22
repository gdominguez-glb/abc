require 'rails_helper'
require 'medium'

RSpec.describe Medium::Scraper do
  let(:post_data) do
    {
      'id' => 'abc123',
      'slug' => 'abc123',
      'success' => true,
      'payload' => {
        'value' => {
          'id' => 'abc123',
          'firstPublishedAt' => 1442815858000,
          'title' => 'Hello Title',
          'content' => {
            'subtitle' => 'Hello SubTitle',
            'bodyModel' => {
              'paragraphs' => [
                {},
                {
                  'type' => 1,
                  'text' => 'hello world',
                  'markups' => [{"type"=>2, "start"=>2, "end"=>4}]
                }
              ]
            }
          },
          'previewContent' => {
            'bodyModel' => {
              'paragraphs' => [
                {},
                {
                  'type' => 1,
                  'text' => 'hello world',
                  'markups' => [{"type"=>2, "start"=>2, "end"=>4}]
                }
              ]
            }
          }
        }
      }
    }
  end
  let!(:medium_publication) { create(:medium_publication, url: 'http://medium.com/abc123', slug: 'abc123') }

  before(:each) do
    stub_request(:get, "http://medium.com/abc123/latest?format=json").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => ("])}while(1);</x>" + {'payload' => { 'posts' => [ post_data ] } }.to_json), :headers => {})
    
    stub_request(:get, "http://medium.com/abc123/abc123-abc123?format=json").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => ("])}while(1);</x>" + post_data.to_json), :headers => {})

    Medium::Scraper.new.scrape_publications
  end

  it "import posts from medium" do
    expect(Post.count).to eq(1)
  end
end
