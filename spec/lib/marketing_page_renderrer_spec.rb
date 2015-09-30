require 'rails_helper'
require 'marketing_page_renderrer'

RSpec.describe MarketingPageRenderrer do
  before(:each) do
    page = Page.new(
      tiles: {
        rows: 
        [
          {
            'rowType' => '50/50 Content Image Left',
            'title' => 'Hello',
            'body_text' => 'hello body',
            'background_color' => 'green',
            'button_title' => 'hello btn',
            'button_link' => 'http://aa.com',
            'image_url' => 'http://img.com/123'
          }
        ]
      }
    )
    @result = MarketingPageRenderrer.new(page).render
  end

  it "render generate html from rows" do
    expect(@result).to eq("<section class=\"row background-color-bg\">\n  <div class=\"col-sm-6 col-centered-content\">\n    <div class=\"vertical-center\">\n      <img src=\"image-url\" class=\"img-responsive img-book margin-sm-bottom-xl\">\n    </div>\n  </div>\n  <div class=\"col-sm-6 col-centered-content\">\n    <div class=\"vertical-center\">\n      <h6>title</h6>\n      <p>body-text</p>\n      <a class=\"btn btn-default btn-block-xs\" href=\"button-link\">button-title</a>\n    </div>\n  </div>\n</section>\n")
  end
end
