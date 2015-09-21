require 'rails_helper'
require 'marketing_page_renderrer'

RSpec.describe MarketingPageRenderrer do
  before(:each) do
    page = Page.new(
      tiles: {
        rows: 
        [
          {
            'rowType' => 'Masthead',
            'title' => 'Hello',
            'background_image' => 'http://img.com/123'

          }
        ]
      }
    )
    @result = MarketingPageRenderrer.new(page).render
  end

  it "render generate html from rows" do
    expect(@result).to eq("<div class=\"masthead\">\n  <h1>Hello</h1>\n  <div>http://img.com/123</div>\n</div>\n")
  end
end
