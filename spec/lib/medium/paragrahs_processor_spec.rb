require 'rails_helper'
require 'medium'

RSpec.describe Medium::ParagraphsProcessor do
  let(:url) { 'http://medium.com/abc' }

  describe "figure" do
    before(:each) do
      stub_request(:get, url).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "<img data-image-id='abc123' src='http://img.medium/123.jpg'/>", :headers => {})
    end

    it "process figure" do
      paragraphs = [{
        'type' => 4,
        'text' => 'test figure',
        'metadata' => { 'id' => 'abc123' }
      }]
      result = Medium::ParagraphsProcessor.new(paragraphs: paragraphs, url: url).process
      expect(result).to eq("        <figure>\n          <div>\n            <img src='http://img.medium/123.jpg' class='post-image'/>\n          </div>\n          <figcaption class=\"imageCaption\">test figure</figcaption>\n        </figure>\n")
    end
  end

  describe "paragraph" do
    it "process paragraph" do
      paragraphs = [{
        'type' => 1,
        'text' => 'hello world',
        'markups' => [{"type"=>2, "start"=>2, "end"=>4}]
      }]
      result = Medium::ParagraphsProcessor.new(paragraphs: paragraphs, url: url).process
      expect(result).to eq("<p>he<em>ll</em>o world</p>")
    end
  end
end
