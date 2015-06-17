require 'httparty'
require 'medium/scraper'
require 'medium/post_processor'
require 'medium/paragraphs_processor'
require 'medium/markups_processor'

module Medium
  PARAGRAPH_TYPES = {
    1 => 'p',
    2 => 'h2',
    3 => 'h3',
    9 => 'li',
    13 => 'h4'
  }

  MARKUP_TYPES = {
    1 => 'strong',
    2 => 'em',
    3 => 'a'
  }
end
