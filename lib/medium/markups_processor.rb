module Medium
  class MarkupsProcessor
    attr_accessor :text, :markups

    def initialize(opts={})
      @text    = opts[:text]
      @markups = opts[:markups]
    end

    def process
      return text if markups.blank?
      texts = construct_matched_texts
      process_prev_text(texts)
      process_next_text(texts)
      assemble_tags(texts)
    end

    def assemble_tags(texts)
      texts.map do |text_data|
        "#{text_data[:prev].join('')}#{text_data[:text]}#{text_data[:next].join('')}"
      end.join('')
    end

    def construct_matched_texts
      texts = []
      positions = markups.map { |markup| [markup['start'], markup['end']] }.flatten.uniq.sort
      positions.each_with_index do |position, index|
        if index < (positions.length - 1)
          texts << ({ prev: [], text: text[position..(positions[index+1]-1)], next: [], start: position, end: positions[index+1] })
        end
      end
      texts
    end

    def process_prev_text(texts)
      process_text(markups.sort_by {|m| m['start'] }, texts, 'start', :prev)
    end

    def process_next_text(texts)
      process_text(markups.sort_by {|m| -m['end'] }, texts, 'end', :next)
    end

    def process_text(markups, texts, text_direction, direction)
      markups.each do |markup|
        matched_text = texts.select{|text| text[text_direction.to_sym] == markup[text_direction]}.first
        matched_text[direction] << "<#{'/' if direction == :next }#{markup_tag(markup['type'])}>"
      end
    end

    def markup_tag(type)
      MARKUP_TYPES[type] || 'span'
    end

    # html_doc.xpath('//img[@data-image-id="1*vK0l5i5zKwbUkFtbo4jaaA.png"]')
  end
end
