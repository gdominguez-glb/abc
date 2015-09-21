require 'rails_helper'
require 'medium'

RSpec.describe Medium::PostProcessor do
  let(:data) do
    {
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
  let(:url) { 'http://medium.com/abc' }

  before(:each) do
    @post_data = Medium::PostProcessor.new(data: data, url: url).process
  end

  it "set medium id" do
    expect(@post_data[:medium_id]).to eq('abc123')
  end

  it "set title" do
    expect(@post_data[:title]).to eq('Hello Title')
  end

  it "set subtitle" do
    expect(@post_data[:subtitle]).to eq('Hello SubTitle')
  end

  it "set published_at" do
    expect(@post_data[:published_at]).to eq(Time.at(1442815858000/1000))
  end

  it "set body" do
    expect(@post_data[:body]).to eq("<p>he<em>ll</em>o worl</p>")
  end

  it "set preview_conetnt" do
    expect(@post_data[:body]).to eq("<p>he<em>ll</em>o worl</p>")
  end
end 
