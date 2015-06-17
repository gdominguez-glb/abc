module Medium
  class PostProcessor
    include ActionView::Helpers::TagHelper

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

    def initialize(opts={})
      @data = opts[:data]
    end

    def process
      return {} if @data['success'] != true
      post_paragraphs = @data['payload']['value']['content']['bodyModel']['paragraphs']
      title           = @data['payload']['value']['title']
      subtitle        = @data['payload']['value']['content']['subtitle']
      medium_id       = @data['payload']['value']['id']
      published_at    = Time.at(@data['payload']['value']['latestPublishedAt']/1000)
      {
        medium_id: medium_id,
        published_at: published_at,
        title: title,
        subtitle: subtitle,
        body: process_paragraphs(post_paragraphs)
      }
    end

    def process_paragraphs(post_paragraphs)
      post_paragraphs.map do |paragraph|
        process_paragraph(paragraph)
      end.join("\n")
    end

    # keys: name, type, text, markups: [type, start, end]
    def process_paragraph(paragraph)
      type    = paragraph['type']
      text    = paragraph['text']
      markups = paragraph['markups']
      tag     = PARAGRAPH_TYPES[type]
      "<#{tag}>#{process_paragrah_markups(text, markups)}</#{tag}>"
    end

    def process_paragrah_markups(text, markups)
      return text if markups.blank?
      positions = markups.map { |markup| [markup['start'], markup['end']] }.flatten.uniq.sort
      texts = []
      positions.each_with_index { |position, index|
        if index < (positions.length - 1)
          texts << ({ prev: [], text: text[position..(positions[index+1]-1)], next: [], start: position, end: positions[index+1] })
        end
      }
      markups.sort_by {|m| m['start'] }.each do |markup|
        matched_text = texts.select{|text| text[:start] == markup['start']}.first
        matched_text[:prev] << "<#{markup_tag(markup['type'])}>"
      end
      markups.sort_by {|m| -m['end'] }.each do |markup|
        matched_text = texts.select{|text| text[:end] == markup['end']}.first
        matched_text[:prev] << "</#{markup_tag(markup['type'])}>"
      end
      texts.map do |text_data|
        "#{text_data[:prev].join('')}#{text_data[:text]}#{text_data[:next].join('')}"
      end.join('')
    end

    def paragraph_tag(type)
      PARAGRAPH_TYPES[type] || 'span'
    end

    def markup_tag(type)
      MARKUP_TYPES[type] || 'span'
    end

    # html_doc.xpath('//img[@data-image-id="1*vK0l5i5zKwbUkFtbo4jaaA.png"]')
  end
end
