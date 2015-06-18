require 'httparty'
require 'medium/scraper'
require 'medium/post_processor'
require 'medium/paragraphs_processor'
require 'medium/markups_processor'
require 'medium/figure_processor'

module Medium
  PARAGRAPH_TYPES = {
    1 => 'p',
    2 => 'h2',
    3 => 'h3',
    9 => 'li',
    13 => 'h4'
  }

  FIGURE_TAG_TYPE = 4

  MARKUP_TYPES = {
    1 => 'strong',
    2 => 'em',
    3 => 'a'
  }

  LINK_TAG = 'a'
  LINK_ATTRIBUTES = ['href', 'title', 'rel']
end
