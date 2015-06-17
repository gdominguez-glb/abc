module Medium
  class MarkupsProcessor
    attr_accessor :text, :markups

    def initialize(opts={})
      @text    = opts[:text]
      @markups = opts[:markups]
    end

    def process
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

    def markup_tag(type)
      MARKUP_TYPES[type] || 'span'
    end

    # html_doc.xpath('//img[@data-image-id="1*vK0l5i5zKwbUkFtbo4jaaA.png"]')
  end
end
