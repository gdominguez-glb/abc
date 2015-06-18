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
      positions = construct_positions
      positions.each_with_index do |position, index|
        if index < (positions.length - 1)
          texts << ({ prev: [], text: text[position..(positions[index+1]-1)], next: [], start: position, end: positions[index+1] })
        end
      end
      texts
    end

    def construct_positions
      positions = markups.map { |markup| [markup['start'], markup['end']] }.flatten
      positions << 0
      positions << (text.length - 1)
      positions.uniq.sort
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
        matched_text[direction] << generate_tag(markup, direction)
      end
    end

    def generate_tag(markup, direction)
      tag = markup_tag(markup['type'])
      return "</#{tag}>" if direction == :next
      return generate_link_tag(markup) if tag == LINK_TAG
      "<#{tag}>"
    end

    def generate_link_tag(markup)
      attributes = LINK_ATTRIBUTES.map do |attr|
        "#{attr}='#{markup[attr]}'"
      end.join(' ')
      "<a #{attributes}>"
    end

    def markup_tag(type)
      MARKUP_TYPES[type] || 'span'
    end

    # html_doc.xpath('//img[@data-image-id="1*vK0l5i5zKwbUkFtbo4jaaA.png"]')
  end
end
