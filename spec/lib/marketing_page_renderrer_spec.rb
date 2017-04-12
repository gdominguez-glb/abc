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
            'body_text' => '<span>hello body</span>',
            'background_color' => 'green',
            'button_title' => 'hello btn',
            'button_link' => 'http://aa.com',
            'button_target' => '_blank',
            'image_url' => 'http://img.com/123'
          }
        ]
      }
    )
    @result = MarketingPageRenderrer.new(page).render
  end

  it "render generate html from rows" do
    expect(@result).to eq("<section class=\"row green-bg\">\n  <div class=\"col-sm-6 col-centered-content\">\n    <div class=\"vertical-center\">\n      <picture>\n        <!--[if IE 9]><video style=\"display: none;\"><![endif]-->\n        <source srcset=\"http://img.com/123\" media=\"(min-width: 361px)\">\n        <!--[if IE 9]></video><![endif]-->\n        <img srcset=\"http://img.com/123\" alt=\"\"  class=\"img-responsive margin-bottom--xl--sm-min\">\n      </picture>\n    </div>\n  </div>\n  <div class=\"col-sm-6 col-centered-content\">\n    <div class=\"vertical-center\">\n      <h6>Hello</h6>\n      <p><span>hello body</span></p>\n      \n        \n          \n        \n        <a class=\"btn btn-default btn-block-xs\" href=\"http://aa.com\" target=\"_blank\">hello btn</a>\n      \n    </div>\n  </div>\n</section>\n")
  end
end
