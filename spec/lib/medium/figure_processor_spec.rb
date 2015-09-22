require 'rails_helper'
require 'medium'

RSpec.describe Medium::FigureProcessor do
  let(:paragraph) do
    {
      'text' => 'test figure',
      'metadata' => { 'id' => 'abc123' }
    }
  end

  before(:each) do
    url = 'http://medium.com/abc'
    @figure_processor = Medium::FigureProcessor.new(url: url, paragraph: paragraph)
    stub_request(:get, url).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "<img data-image-id='abc123' src='http://img.medium/123.jpg'/>", :headers => {})
  end

  it "generate figure html" do
    figure_html = @figure_processor.process

    expect(figure_html).to eq("        <figure>\n          <div>\n            <img src='http://img.medium/123.jpg' class='post-image'/>\n          </div>\n          <figcaption class=\"imageCaption\">test figure</figcaption>\n        </figure>\n")
  end
end
